import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Map"
import "../Singletons"
import "../_OneMakerMV"

GroupBoxRow {
    id: root

    property alias list: listBox.list
    property alias characterId: characterSelectBox.currentId
    property alias option1: checkBox1.checked
    property alias option2: checkBox2.checked
    property alias option3: checkBox3.checked
    property alias characterSelectable: characterSelectBox.enabled
    property alias waitCheckable: checkBox3.enabled

    // [OneMaker MV] - properties for map information
    property bool showMap: false
    property int mapX: 0
    property int mapY: 0
    property int eventId: 0
    property string eventName: ""

    signal triggered(var code)

    GroupBoxColumn {
        width: 220 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") // [OneMaker MV] - Window Increased
        ControlsRow { // [OneMaker MV] - Append to a Control Row
            CharacterSelectBox {
                id: characterSelectBox
                title: qsTr("Character")
                hint: qsTr("Character to be assigned the movement route.")
                labelVisible: false
                itemWidth: (200 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease")) / 1.45 // [OneMaker MV] - Divide width to account for new button
            }
            // [OneMaker MV] - Add Show Map Button
            Button {
                id: showMapButton
                text: qsTr("Show Map")
                hint: qsTr("")
                width: (200 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease")) / 3
                onClicked: root.toggleMap()
            }
        }
        
        MovementCommandListBox {
            id: listBox
            title: qsTr("Command List")
            hint: qsTr("Movement commands to be run. Press a button on the right to add a new command.")
            width: parent.width
            height: 262
            list: [ { code: 0 } ]
        }
        GroupBox {
            id: optionsGroup
            title: qsTr("Options")
            hint: qsTr("Options for the movement route behavior.")
            height: 100 // [OneMaker MV] - Force Height
            width: parent.width
            ControlsRow { // [OneMaker MV] - Append to Control Row
                ControlsColumn {
                    CheckBox {
                        id: checkBox1
                        text: qsTr("Repeat Movements")
                        hint: qsTr("After running all the commands, returns to the top of the list.")
                    }
                    CheckBox {
                        id: checkBox2
                        text: qsTr("Skip If Cannot Move")
                        hint: qsTr("Skips any command that would move a character into an impassable location.")
                    }
                    CheckBox {
                        id: checkBox3
                        text: qsTr("Wait for Completion")
                        hint: qsTr("Waits for the movements to finish.")
                        checked: true
                    }
                }
                // [OneMaker MV] - Add selected tile information
                ControlsColumn {
                    Label {
                        text: qsTr("Event Id: " + eventId)
                        width: 100
                        visible: showMap
                    }
                    Label {
                        text: qsTr("Event Name:")
                        width: 100
                        visible: showMap
                    }
                    Label {
                        text: qsTr(eventName)
                        width: 100
                        visible: showMap
                    }
                }
                ControlsColumn {
                    Label {
                        text: qsTr("Cursor X: " + mapX)
                        visible: showMap
                    }
                    Label {
                        text: qsTr("Curosr Y: " + mapY)
                        visible: showMap
                    }
                }
            }
            
        }
        // [OneMaker MV] - Add a Minimap
        ControlsRow {
            MapEditorBaseView {
                id: mapView
                editMode: 1
                width: 665 + (OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") * 2)
                height: 224 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease")
                tileScale: 1/2
                mapId: DataManager.currentMapId
                visible: showMap

                onCursorRectChanged: {
                    if (cursorRect.width === 1) {
                        root.mapX = cursorRect.x;
                        root.mapY = cursorRect.y;

                        var currentEvent = getEvent(mapX, mapY)
                        root.eventId = currentEvent ? currentEvent.id : 0
                        root.eventName = currentEvent ? currentEvent.name : ""
                    }
                }
            }
        }
    }

    GroupBox {
        title: qsTr("Movement Commands")
        Row {
            spacing: 8
            Repeater {
                model: 3
                Column {
                    property int columnIndex: index
                    Repeater {
                        model: 15
                        GroupButton {
                            property int rowIndex: index
                            property int commandCode: columnIndex * 15 + rowIndex + 1

                            onCommandCodeChanged: {
                                text = MovementCommands.buttonText(commandCode);
                                hint = MovementCommands.hint(commandCode);
                            }

                            onClicked: root.triggered(commandCode);
                        }
                    }
                }
            }
        }
    }

    Dialog_MovementCommand {
        id: commandDialog
        onOk: listBox.insert(movementData)
    }

    onTriggered: {
        if (MovementCommands.flag(code) === 0) {
            var data = [ { code: code } ];
            listBox.insert(data);
        } else {
            commandDialog.movementCode = code;
            commandDialog.movementData = null;
            commandDialog.open();
        }
    }

    function setCharacterId(id) {
        characterSelectBox.setCurrentId(id);
    }

    // [OneMaker MV] - Get event information for the selected tile
    function getEvent(x, y) {
        var map = DataManager.maps[mapId];
        if (map && map.events) {
            for (var i = 0; i < map.events.length; i++) {
                var event = map.events[i];
                if (event && event.x === x && event.y === y) {
                    return event;
                }
            }
        }
        else {
            return ""
        }
    }

    // [OneMaker MV] - Toggle Map function
    function toggleMap() {
        showMap = !showMap;
    }
}
