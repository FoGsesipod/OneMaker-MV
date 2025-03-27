import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

GroupBox {
    id: root

    title: qsTr("Operand")
    hint: qsTr("Amount by which to increase or decrease.")

    property alias minimumValue: constantSpinBox.minimumValue
    property alias maximumValue: constantSpinBox.maximumValue

    readonly property int operandType: group.current.value
    readonly property int operandValue: operandType === 0 ? constantSpinBox.value : variableBox.variableId

    property bool full: false
    property int troopId: 0

    property int radioButtonWidth: 100
    property int itemHeight: 28

    // [OneMaker MV] - Self Variable Operand
    property bool allowSelfVariableOperand: false

    ControlsColumn {
        ExclusiveGroup { id: group }

        ControlsRow {
            RadioButton {
                id: radioButton1
                text: qsTr("Constant")
                hint: qsTr("Uses the constant value.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                value: 0
                checked: true
            }
            SpinBox {
                id: constantSpinBox
                title: radioButton1.title
                hint: radioButton1.hint
                enabled: radioButton1.checked
                width: 100
                minimumValue: 1
                maximumValue: 9999
            }
        }

        ControlsRow {
            RadioButton {
                id: radioButton2
                text: qsTr("Variable")
                hint: qsTr("Uses the value of the specified variable.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                value: 1
            }
            GameVariableBox {
                id: variableBox
                title: radioButton2.title
                hint: radioButton2.hint
                enabled: radioButton2.checked
                labelVisible: false
            }
        }

        ControlsRow {
            visible: root.full
            RadioButton {
                id: radioButton3
                text: qsTr("Random")
                hint: qsTr("Uses a random value between two specified values.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                value: 2
            }
            SpinBox {
                id: randomSpinBox1
                title: radioButton3.title
                hint: radioButton3.hint
                enabled: radioButton3.checked
                width: 100
                minimumValue: root.minimumValue
                maximumValue: root.maximumValue
            }
            Label {
                text: "~"
                anchors.verticalCenter: parent.verticalCenter
                title: radioButton3.title
                hint: radioButton3.hint
                enabled: radioButton3.checked
            }
            SpinBox {
                id: randomSpinBox2
                title: radioButton3.title
                hint: radioButton3.hint
                enabled: radioButton3.checked
                width: 100
                minimumValue: root.minimumValue
                maximumValue: root.maximumValue
            }
        }

        ControlsRow {
            visible: root.full
            RadioButton {
                id: radioButton4
                text: qsTr("Game Data")
                hint: qsTr("Uses a value from various data in the game.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                value: 3
            }
            GameDataOperandBox {
                id: gameDataOperandBox
                title: radioButton4.title
                hint: radioButton4.hint
                enabled: radioButton4.checked
                width: 300
                troopId: root.troopId
            }
        }

        ControlsRow {
            visible: root.full
            RadioButton {
                id: radioButton5
                text: qsTr("Script")
                hint: qsTr("Evaluates text as JavaScript.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                value: 4
            }
            TextField {
                id: scriptBox
                title: radioButton5.title
                hint: radioButton5.hint
                enabled: radioButton5.checked
                width: 300

                contextMenu: TextEditPopupMenu {
                    MenuSeparator { }
                    MenuItem_PluginHelpEverywhere { }
                }
            }
        }

        // [OneMaker MV] - Self Variable Operand
        ControlsRow {
            visible: root.full
            RadioButton {
                id: radioButton6
                text: qsTr("Self Variable")
                hint: qsTr("Uses the value of the specified self variable.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root. itemHeight
                value: 5
            }
            ObjComboBox {
                id: selfVariableBox
                title: radioButton6.title
                hint: radioButton6.hint
                enabled: radioButton6.checked
                model: OneMakerMVSettings.getSetting("selfVariableNaming", "namingScheme")
                itemWidth: 90
                labelVisible: false
            }
        }
    }

    function setup(operandType, operandValue1, operandValue2, operandValue3) {
        switch (operandType) {
        case 0:
            radioButton1.checked = true;
            constantSpinBox.value = operandValue1;
            break;
        case 1:
            radioButton2.checked = true;
            variableBox.variableId = operandValue1;
            break;
        case 2:
            radioButton3.checked = true;
            randomSpinBox1.value = operandValue1;
            randomSpinBox2.value = operandValue2;
            break;
        case 3:
            radioButton4.checked = true;
            gameDataOperandBox.type = operandValue1;
            gameDataOperandBox.param1 = operandValue2;
            gameDataOperandBox.param2 = operandValue3;
            break;
        case 4:
            // [OneMaker MV] - Workaround for EventCommand122 (Control Variables)
            var selfVarMatch = /^this\.selfVariableValue\((\d+)\)$/.exec(operandValue1);
            if (!allowSelfVariableOperand &&
                selfVarMatch && (+selfVarMatch[1] >= 0) && (+selfVarMatch[1] < selfVariableBox.count)
            ) {
                radioButton6.checked = true;
                selfVariableBox.currentIndex = +selfVarMatch[1];
            } else {
                radioButton5.checked = true;
            }
            scriptBox.text = operandValue1;
            break;
        // [OneMaker MV] - Added case 5, self variables 
        case 5:
            radioButton6.checked = true;
            selfVariableBox.currentIndex = operandValue1;
            break;
        }
    }

    function makeFullOperandParams() {
        var params = [];
        params.push(operandType);
        switch (operandType) {
        case 0:
            params.push(constantSpinBox.value);
            break;
        case 1:
            params.push(variableBox.variableId);
            break;
        case 2:
            params.push(Math.min(randomSpinBox1.value, randomSpinBox2.value));
            params.push(Math.max(randomSpinBox1.value, randomSpinBox2.value));
            break;
        case 3:
            params.push(gameDataOperandBox.type);
            params.push(gameDataOperandBox.param1);
            params.push(gameDataOperandBox.param2);
            break;
        case 4:
            params.push(scriptBox.text);
            break;
        // [OneMaker MV] - Added case 5, self variables 
        case 5:
            if (allowSelfVariableOperand) {
                params.push(selfVariableBox.value);
            } else {
                params[0] = 4;
                params.push("this.selfVariableValue(" + selfVariableBox.value + ")");
            }
            break;
        }
        return params;
    }
}
