import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Plugin Manager")

    autoCloseOnCancel: false

    DialogBox {
        id: dialogBox

        onInit: {
            DataManager.backupPlugins();
        }
        onOk: {
            DataManager.pluginsModified = true;
            DataManager.backupPlugins();
            TutorialManager.onOkDialog("PluginManager", root);
        }
        onApply: {
            DataManager.pluginsModified = true;
            DataManager.backupPlugins();
            applyEnabled = false;
        }
        onCancel: {
            if (applyEnabled) {
                dialogBox.openDiscardConfirm(function() {
                    root.emitCancel();
                });
            } else {
                root.emitCancel();
            }
            TutorialManager.onCancelDialog("PluginManager", root);
        }
        onClosing: {
            if (applyEnabled) {
                close.accepted = false;
                dialogBox.openDiscardConfirm(function() {
                    root.emitClose();
                });
            }
        }

        MessageBox {
            id: discardConfirmBox
            iconType: "warning"
            useYesNo: true
            message: qsTr("Discard changes to the plugins?");

            property var callback
            property bool result

            resources: Timer {
                id: callbackTimer
                interval: 1
                onTriggered: discardConfirmBox.callback(discardConfirmBox.result)
            }

            onYes: {
                result = true;
                callbackTimer.start();
            }

            onNo: {
                result = false;
                callbackTimer.start();
            }
        }

        function openDiscardConfirm(callback) {
            discardConfirmBox.callback = function(answer) {
                if (answer) {
                    DataManager.restorePlugins();
                    callback();
                }
            }
            discardConfirmBox.open();
        }

        Dialog_PluginSettings {
            id: dialog
            onOk: {
                var data = {};
                data.name = pluginName;
                data.status = pluginStatus;
                data.description = pluginDesc;
                data.parameters = parameters;
                listBox.finishEdit(data);
            }
        }

        SmartListBox {
            id: listBox
            title: qsTr("Plugin List")
            hint: qsTr("Components that extend the standard game system.")
            width: 760
            height: 742 // Increased by 200
            object: null
            member: "plugins"
            dragDrop: true
            findManager: findMgr
            showSelectionAlways: true

            function getDataArray() {
                return DataManager.plugins;
            }

            ListBoxColumn {
                title: qsTr("Name")
                role: "name"
                width: 170
            }
            ListBoxColumn {
                title: qsTr("Status")
                role: "status"
                width: 80
            }
            ListBoxColumn {
                title: qsTr("Description")
                role: "description"
                width: 492
            }

            Connections {
                id: connectionTurnOn
                target: null
                onTriggered: {
                    listBox.changeSelectedItemStatuses(true);
                }
            }
            Connections {
                id: connectionTurnOff
                target: null
                onTriggered: {
                    listBox.changeSelectedItemStatuses(false);
                }
            }
            Connections {
                id: connectionRefresh
                target: null
                onTriggered: {
                    listBox.refreshSelectedItem();
                }
            }

            Component.onCompleted: {
                contextMenu.addSeparator();
                var turnOnItem = contextMenu.addItem(qsTr("Turn ON"));
                var turnOffItem = contextMenu.addItem(qsTr("Turn OFF"));
                contextMenu.addSeparator();
                var refreshItem = contextMenu.addItem(qsTr("Refresh"));
                turnOnItem.enabled = Qt.binding(function() {
                    return !listBox.emptyItemSelected;
                });
                turnOffItem.enabled = Qt.binding(function() {
                    return !listBox.emptyItemSelected;
                });
                refreshItem.enabled = Qt.binding(function() {
                    return !listBox.emptyItemSelected;
                });
                connectionTurnOn.target = turnOnItem;
                connectionTurnOff.target = turnOffItem;
                connectionRefresh.target = refreshItem;
            }

            function editItem(data) {
                if (data) {
                    dialog.pluginName = String(data.name || "");
                    dialog.pluginStatus = !!data.status;
                    dialog.parameters = data.parameters || {};
                } else {
                    dialog.reset();
                }
                dialog.open();
            }

            function makeModelItem(data) {
                var item = {};
                if (data) {
                    item.name = data.name || "";
                    item.status = data.status ? qsTr("ON") : qsTr("OFF");
                    item.description = (data.description || "").replace(/\n/g, " ");
                } else {
                    item.name = "";
                    item.status = "";
                    item.description = "";
                }
                return item;
            }

            function changeSelectedItemStatuses(status) {
                var array = getDataArray();
                for (var i = 0; i < rowCount - 1; i++) {
                    if (isSelected(i)) {
                        array[i].status = status;
                        model.set(i, makeModelItem(array[i]));
                    }
                }
                dialogBox.setModified();
            }

            function refreshSelectedItem() {
                var array = getDataArray();
                for (var i = 0; i < rowCount - 1; i++) {
                    if (isSelected(i)) {
                        var data = array[i];
                        var url = DataManager.projectUrl + "js/plugins" + "/" + data.name + ".js";
                        var parsed = PluginParser.parseScriptURL(url);
                        var parameters = data.parameters;
                        var newParameters = {};
                        for (var j = 0; j < parsed.paramNames.length; j++) {
                            var name = parsed.paramNames[j];
                            var value = parsed.paramDefaults[name] || "";
                            if (parameters[name] !== undefined) {
                                value = parameters[name];
                            }
                            newParameters[name] = value;
                        }
                        data.parameters = newParameters;
                        data.description = parsed.pluginDesc;

                        model.set(i, makeModelItem(array[i]));
                    }
                }
                dialogBox.setModified();
            }
        }

        FindManager {
            id: findMgr
            scopeTitle: qsTr("Plugin List")

            searchableFields: ([
                { name: "name", title: qsTr("Name"), hint: qsTr("Name of the plugin.") },
                { name: "description", title: qsTr("Description"), hint: qsTr("Description of the plugin.") },
            ])

            function getItemCount() {
                return listBox.rowCount;
            }

            function getItem(index) {
                return listBox.model.get(index);
            }

            function getCurrentIndex() {
                return listBox.currentIndex;
            }

            function setCurrentIndex(index) {
                listBox.currentIndex = index;
                listBox.positionViewAtIndex(listBox.currentIndex, ListView.Contain);
            }
        }
    }
}
