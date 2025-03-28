import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Plugin Help")

    property string text

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        DialogBoxColumn {
            DialogBoxRow {
                ListBox {
                    id: pluginList
                    width: 200 + (OneMakerMVSettings.getWindowSetting("windowSizes", "alternativeWidthIncrease") * 2)
                    height: 360 + (OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease") * 2)

                    headerVisible: false
                    multiSelect: false
                    showSelectionAlways: true
                    wantReturn: false

                    model: ListModel {
                        id: listModel
                    }

                    function refresh() {
                        var array = getDataArray();
                        listModel.clear();
                        for (var i = 0; i < array.length; i++) {
                            listModel.append(makeModelItem(array[i]));
                        }
                    }

                    ListBoxColumn {
                        role: "name"
                    }

                    function getDataArray() {
                        return DataManager.plugins;
                    }

                    function makeModelItem(data) {
                        var item = {};
                        if (data) {
                            item.name = data.name || "";
                            item.status = data.status ? qsTr("ON") : qsTr("OFF");
                            item.description = (data.description || "").replace(/\n/g, " ");
                        }
                        return item;
                    }

                    onCurrentIndexChanged: {
                        loadScript();
                    }

                    function loadScript() {
                        var name = model.get(currentIndex).name;
                        DataManager.lastPluginName = name;

                        var url = DataManager.projectUrl + "js/plugins" + "/" + name + ".js";
                        var script = TkoolAPI.readFile(url);
                        var re = /\/\*\:([a-zA-Z_]*)([\s\S]*?)\*\//mg;
                        var locale = TkoolAPI.locale();
                        var englishComments = "";
                        var localComments = "";
                        pluginHelp.text = "";
                        for (;;) {
                            var match = re.exec(script);
                            if (match) {
                                var lang = match[1];
                                if (!lang || lang === "en") {
                                    englishComments = match[2];
                                } else if (lang.length >= 2 && locale.indexOf(lang) === 0) {
                                    localComments = match[2];
                                }
                            } else {
                                break;
                            }
                        }
                        if (localComments) {
                            processCommentBlock(localComments);
                        } else {
                            processCommentBlock(englishComments);
                        }
                    }

                    function processCommentBlock(comments) {
                        var re = /@(\w+)([^@]*)/g;
                        for (;;) {
                            var match = re.exec(comments);
                            if (!match) {
                                break;
                            }
                            var keyword = match[1];
                            var text = match[2];
                            text = text.replace(/[ ]*\n[ ]*\*?[ ]?/g, "\n");
                            text = text.trim();
                            var text2 = text.split("\n")[0];
                            switch (keyword) {
                            case 'help':
                                pluginHelp.text = text;
                                break;
                            }
                        }
                    }
                }

                TextArea {
                    id: pluginHelp
                    width: 200 + (OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease") * 2)
                    height: 360 + (OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") * 2)
                    readOnly: true
                    selectAllOnFocus: false
                }
            }
        }

        onInit: {
            pluginList.refresh();

            for (var i = 0; i < pluginList.rowCount; i++) {
                if (DataManager.lastPluginName == listModel.get(i).name) {
                    pluginList.currentIndex = i;
                }
            }
        }
    }
}
