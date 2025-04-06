import QtQuick 2.3
import QtQuick.Controls 1.2
import Qt.labs.folderlistmodel 2.1
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root

    title: qsTr("Plugin")

    property string pluginName: ""
    property bool pluginStatus: true
    property string pluginHelp: ""
    property string pluginDesc: ""
    property string pluginAuthor: ""
    property var parameters: ({})

    function reset() {
        pluginHelp = "";
        pluginName = "";
        pluginStatus = true;
        pluginDesc = "";
        pluginAuthor = "";
        parameters = {};
    }

    DialogBox {
        id: main
        applyVisible: false
        okEnabled: pluginSelector.currentText !== ""

        onInit: {
            statusBox.currentIndex = pluginStatus ? 0 : 1;
        }

        onOk: {
            pluginName = pluginSelector.currentText;
            pluginStatus = statusBox.currentIndex === 0;
            parameters = parameterListBox.dumpParameters();
        }

        GroupBoxRow {
            GroupBoxColumn {
                GroupBoxRow {
                    GroupBox {
                        title: qsTr("General Settings")
                        hint: qsTr("Basic plugin settings.")

                        FolderListModel {
                            id: folderListModel
                            folder: DataManager.projectUrl + "js/plugins"
                            nameFilters: ["*.js"]
                            showDirs: false
                            onCountChanged: {
                                scriptListModel.clear();
                                for (var i = 0; i < folderListModel.count; i++) {
                                    var name = folderListModel.get(i, "fileBaseName");
                                    scriptListModel.append({ value: name });
                                }
                                pluginSelector.select(pluginName);
                            }
                        }

                        ListModel {
                            id: scriptListModel
                        }

                        Palette { id: pal }

                        Column {
                            spacing: 8
                            ControlsRow {
                                LabeledComboBox {
                                    id: pluginSelector
                                    title: qsTr("Name")
                                    hint: qsTr("Name of the plugin script.")
                                    model: scriptListModel
                                    onCurrentTextChanged: main.loadScript()
                                    currentIndex: -1
                                    fontFamily: pal.fixedFont
                                    itemWidth: 410
                                }
                                LabeledComboBox {
                                    id: statusBox
                                    title: qsTr("Status")
                                    hint: qsTr("ON/OFF status of the plugin.")
                                    itemWidth: 140
                                    model: [qsTr("ON"), qsTr("OFF")]
                                }
                            }
                            DescriptionBox {
                                title: qsTr("Description")
                                hint: qsTr("Description of the plugin.")
                                width: 560 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                                height: 48
                                text: pluginDesc
                            }
                            DescriptionBox {
                                title: qsTr("Author")
                                hint: qsTr("Author of the plugin.")
                                width: 560 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                                height: 28
                                text: pluginAuthor ? title + ": " + pluginAuthor : ""
                            }
                        }
                    }
                }

                GroupBox {
                    title: qsTr("Help")
                    hint: qsTr("Displays the help text of the plugin")

                    Column {
                        TextArea {
                            width: 560 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                            height: 360 + OneMakerMVSettings.getWindowSetting("defaultHeightIncrease") // [OneMaker MV] - Window Increased
                            readOnly: true
                            selectAllOnFocus: false
                            text: root.pluginHelp
                        }
                    }
                }
            }
            GroupBox {
                id: parametersGroup
                title: qsTr("Parameters")
                hint: qsTr("Parameters to be passed to the plugin.")
                Column {
                    PluginSettingBox {
                        id: parameterListBox
                        width: 480
                        height: 541 + OneMakerMVSettings.getWindowSetting("defaultHeightIncrease") // [OneMaker MV] - Window Increased
                        title: parametersGroup.title
                        hint: parametersGroup.hint
                    }
                }
            }
        }

        function loadScript() {
            var name = pluginSelector.currentText;
            var url = folderListModel.folder + "/" + name + ".js";
            var parsed = PluginParser.parseScriptURL(url);
            pluginHelp = parsed.pluginHelp;
            pluginDesc = parsed.pluginDesc;
            pluginAuthor = parsed.pluginAuthor;

            parameterListBox.loadData(parsed, null, (pluginSelector.currentText === pluginName) ? parameters : null);
        }
    }
}
