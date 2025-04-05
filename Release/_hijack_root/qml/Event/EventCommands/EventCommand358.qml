import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"
import "../../_OneMakerMV"

// Switch Statement
EventCommandBase {
    id: root

    property int eventCodeCase: 658
    property int eventCodeEnd: 412

    ExclusiveGroup {
        id: conditionTypeGroup
    }

    GroupBox {
        width: 400
        height: 220
        ControlsColumn {
            y: -14
            ControlsRow {
                RadioButton {
                    id: radioButton1
                    text: qsTr("Variable")
                    hint: qsTr("Based on the value of the specified variable")
                    exclusiveGroup: conditionTypeGroup
                    value: 0
                    width: 120
                    height: 28
                    checked: true
                }
                GameVariableBox {
                    id: variableBox
                    title: radioButton1.title
                    hint: radioButton1.hint
                    labelVisible: false
                    enabled: radioButton1.checked
                }
            }
            ControlsRow {
                RadioButton {
                    id: radioButton2
                    text: qsTr("Self Variable")
                    hint: qsTr("Based on the value of the specified self variable")
                    exclusiveGroup: conditionTypeGroup
                    value: 1
                    width: radioButton1.width
                    height: radioButton1.height
                }
                ObjComboBox {
                    id: selfVariableIdBox
                    title: radioButton2.title
                    hint: radioButton2.hint
                    model: OneMakerMVSettings.getSetting("selfVariableNaming", "namingScheme")
                    itemWidth: 90
                    labelVisible: false
                    enabled: radioButton2.checked
                }
            }
            ControlsRow {
                RadioButton {
                    id: radioButton3
                    text: qsTr("Inventory")
                    hint: qsTr("Based on the quantity of a specific item/weapon/armor.")
                    exclusiveGroup: conditionTypeGroup
                    value: 2
                    width: radioButton1.width
                    height: radioButton1.height
                }
                ObjComboBox {
                    id: itemTypeBox
                    title: radioButton3.title
                    hint: radioButton3.hint
                    itemWidth: 90
                    model: ["Item", "Weapon", "Armor"]
                    enabled: radioButton3.checked
                    labelVisible: false
                }
                GameObjectBox {
                    id: itemValueBox
                    title: radioButton3.title
                    hint: radioButton3.hint
                    itemWidth: 150
                    dataSetName: ["items", "weapons", "armors"][itemTypeBox.currentIndex]
                    enabled: radioButton3.checked
                    labelVisible: false
                }
            }
            ControlsRow {
                RadioButton {
                    id: radioButton4
                    text: qsTr("Direction of")
                    hint: qsTr("Based on the direction the player or event is facing.")
                    value: 3
                    exclusiveGroup: conditionTypeGroup
                    width: radioButton1.width
                    height: radioButton1.height
                }
                CharacterSelectBox {
                    id: characterSelectBox
                    title: radioButton4.title
                    hint: radioButton4.hint
                    enabled: radioButton4.checked
                    labelVisible: false
                }
            }
            ControlsRow {
                RadioButton {
                    id: radioButton5
                    text: qsTr("Script")
                    hint: qsTr("Based on the returned value from a script evaulation.")
                    exclusiveGroup: conditionTypeGroup
                    value: 4
                    width: radioButton1.width
                    height: radioButton1.height
                }
                ObjTextField {
                    id: scriptField
                    title: radioButton5.title
                    hint: radioButton5.hint
                    itemWidth: 250
                    enabled: radioButton5.checked
                    labelVisible: false
                }
            }
        }
    }
    GroupBox {
        width: 400
        height: 500
        ScrollView {
            width: 380
            height: 465
            style: CustomScrollViewStyle {
                frame: Rectangle {
                    color: "transparent"
                }
                Palette { id: pal }
            }

            ControlsColumn {
                ControlsRow {
                    ObjSpinBox {
                        id: caseSpinBox
                        title: qsTr("Case Amounts")
                        hint: qsTr("How many cases to use")
                        width: 90
                        minimumValue: 1
                        maximumValue: 999
                        
                        onValueChanged: {
                            while (listModel.count > value) {
                                listModel.remove(listModel.count - 1);
                            }
                            while (listModel.count < value) {
                                listModel.append({"text": ""});
                            }
                        }
                    }
                }
                
                ListModel {
                    id: listModel
                }
                
                Repeater {
                    id: repeater
                    model: listModel

                    delegate: ObjTextField {
                        id: textField
                        title: qsTr("Case " + index)
                        hint: qsTr("")
                        itemWidth: 360
                        text: listModel.text

                        onTextChanged: {
                            listModel.set(index, {"text": text});
                        }
                    }
                }
                ObjCheckBox {
                    id: defaultCheckBox
                    text: qsTr("Default")
                    hint: qsTr("Add a default case.")
                    width: 360
                    y: 24
                }
            }
        }
    }

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            var cases = params[0];
            caseSpinBox.value = cases.length;
            
            for (var i = 0; i < cases.length; i++) {
                repeater.itemAt(i).text = cases[i];
            }

            switch (params[1]) {
                case 0: // Variable
                    radioButton1.checked = true;
                    variableBox.variableId = params[2];
                    break;
                case 1: // Self Variable
                    radioButton2.checked = true;
                    selfVariableIdBox.currentIndex = params[2];
                    break;
                case 2: // Inventory
                    radioButton3.checked = true;
                    itemTypeBox.currentIndex = params[2];
                    itemValueBox.currentId = params[3];
                    break;
                case 3: // Character Direction
                    radioButton4.checked = true;
                    characterSelectBox.currentIndex = params[2];
                    break;
                case 4: // Script
                    radioButton5.checked = true;
                    scriptField.text = params[2];
                    break;
            }
        }
    }

    onSave: {
        var blockArray = makeBlockArray();
        var topIndent = getTopIndent();
        var cases = [];

        for (var i = 0; i < repeater.count; i++) {
            cases[i] = repeater.itemAt(i).text;
        }

        var params = [];
        params[0] = cases;
        
        if (defaultCheckBox.checked) {
            params[0].push("default")
        }

        var type = conditionTypeGroup.current.value;

        switch (type) {
            case 0: // Variable
                params[1] = 0;
                params[2] = variableBox.variableId;
                break;
            case 1: // Self Variable
                params[1] = 1;
                params[2] = selfVariableIdBox.currentIndex;
                break;
            case 2: // Inventory
                params[1] = 2;
                params[2] = itemTypeBox.currentIndex
                params[3] = itemValueBox.currentId;
                break;
            case 3: // Character Direction
                params[1] = 3;
                params[2] = characterSelectBox.currentIndex;
                break;
            case 4: // Script
                params[1] = 4;
                params[2] = scriptField.text;
                break;
        }

        eventData = []
        eventData.push( makeCommand(eventCode, topIndent, params) )

        for (var i = 0; i < cases.length; i++) {
            eventData.push( makeCommand(eventCodeCase, topIndent, [i, cases[i]]) )
            eventData = eventData.concat(blockArray[i]);
        }

        eventData.push( makeCommand(eventCodeEnd, topIndent, []))
    }

    function makeBlockArray() {
        var blockArray = [];
        var blockIndex = -1;
        var topIndent = getTopIndent();

        if (eventData) {
            for (var i = 0; i < eventData.length; i++) {
                var command = eventData[i];

                if (command.indent === topIndent) {
                    if (command.code === eventCodeCase) {
                        blockIndex = command.parameters[0];
                        blockArray[blockIndex] = [];
                    }
                } else if (blockIndex >= 0) {
                    blockArray[blockIndex].push(command);
                }
            }
        }
        for (var j = 0; j < repeater.count + 1; j++) {
            if (!blockArray[j]) {
                blockArray[j] = [];
            }
            if (blockArray[j].length === 0) {
                blockArray[j].push(makeNullCommand(topIndent + 1));
            }
        }
        return blockArray;
    }
}