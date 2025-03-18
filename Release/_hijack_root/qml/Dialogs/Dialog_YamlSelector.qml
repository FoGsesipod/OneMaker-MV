import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root

    title: qsTr("Select a File")

    property string fileName: ""
    property string messageName: ""
    property string messageText: ""

    property string folder: ""
    property var atlasData: {}

    property int viewWidth: 496
    property bool showIndexText: false

    property string indexTextTitle: ""
    property string indexTextHint: ""

    DialogBox {
        applyVisible: false

        onOk: {
            if (yamlListBox.currentIndex === 0) {
                root.messageName = "";
            } else {
                root.messageName = yamlListBox.currentItem.fileBaseName;
            }
        }

        ControlsRow {
            FileListBox {
                id: listBox

                width: 200 + WindowSizes.defaultWidthIncrease
                height: 402 + WindowSizes.defaultHeightIncrease

                folder: root.folder
                allowedSuffixes: ["yaml"]

                onCurrentBaseNameChanged: {
                    if (currentItem) {
                        root.fileName = currentItem.fileBaseName;
                        extractAtlasNames()
                    }
                }
                onUpdated: {
                    selectName(root.fileName);
                }
                onDoubleClicked: {
                    ok();
                }
            }

            YamlFileListBox {
                id: yamlListBox

                width: listBox.width
                height: listBox.height

                messageData: atlasData
                allowedSuffixes: listBox.allowedSuffixes

                onCurrentBaseNameChanged: {
                    if (currentItem) {
                        root.messageName = currentItem.fileBaseName;
                        getAtlasText(root.messageName);
                    }
                }
                onUpdated: {
                    selectName(root.messageName);
                }
                onDoubleClicked: {
                    ok();
                }
            }    
        }
        TextArea {
            id: textArea
            title: qsTr("Message Text")
            hint: qsTr("")
            width: listBox.width * 2 + 16
            height: 125
            x: -2
            y: listBox.height + 8
            readOnly: true
            selectAllOnFocus: false

            text: root.messageText
        }
    }

    function extractAtlasNames() {
        var tempData = {};
        var fileContent = TkoolAPI.readFile(folder + "/" + fileName + ".yaml");
        var lines = fileContent.split("\n")
        var currentAtlas = "";
        var accumulatingText = "";

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            var shouldIgnoreLine = false;

            for (var j = 0; j < YamlIdentifiers.ignoreIdentifiers.length; j++) {
                if (line.indexOf(YamlIdentifiers.ignoreIdentifiers[j]) === 0) {
                    shouldIgnoreLine = true;
                }
            }

            if (shouldIgnoreLine) {
                continue;
            }
            
            if (line.length > 0 && line.charAt(line.length - 1) === ":") {
                var atlasName = line.substring(0, line.length - 1).trim();
                currentAtlas = atlasName;
                tempData[currentAtlas] = "";
                accumulatingText = "";
            }
            else if (currentAtlas !== "" && line.indexOf("text:") === 0) {
                var textValue = line.substring(line.indexOf(":") + 1).trim();
                accumulatingText += textValue;
                tempData[currentAtlas] = textValue;
            }
            else if (currentAtlas !== "" && accumulatingText !== null) {
                accumulatingText += line;
                tempData[currentAtlas] = accumulatingText;
            }

            if (line.length == 0) {
                currentAtlas = "";
            }
        }
        atlasData = tempData;
        Logger.log("Extracted atlas names:", atlasData);
    }

    function getAtlasText(key) {
        if (atlasData.hasOwnProperty(key)) {
            messageText = atlasData[key]
        }
        else {
            messageText = "";
        }
    }
}
