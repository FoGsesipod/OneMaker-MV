import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"

GroupBoxRow {
    id: root

    property alias list: listBox.list
    property alias characterId: characterSelectBox.currentId
    property alias option1: checkBox1.checked
    property alias option2: checkBox2.checked
    property alias option3: checkBox3.checked
    property alias characterSelectable: characterSelectBox.enabled
    property alias waitCheckable: checkBox3.enabled

    signal triggered(var code)

    GroupBoxColumn {
        width: 420
        CharacterSelectBox {
            id: characterSelectBox
            title: qsTr("Character")
            hint: qsTr("Character to be assigned the movement route.")
            labelVisible: false
            itemWidth: parent.width
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
            width: parent.width
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
}
