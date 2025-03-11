import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Singletons"

Tab {
    id: root

    property ExclusiveGroup exclusiveGroup
    property int radioButtonWidth
    property int radioButtonHeight

    property Item _column: null

    property int subRadioButtonWidth: 100

    TabColumn {

        Row {
            RadioButton {
                id: radioButton1
                text: qsTr("Switch")
                hint: qsTr("Based on the state of the specified switch.")
                exclusiveGroup: root.exclusiveGroup
                value: 0
                width: radioButtonWidth
                height: radioButtonHeight
                checked: true
            }
            ControlsRow {
                enabled: radioButton1.checked
                GameSwitchBox {
                    id: switchBox
                    title: radioButton1.title
                    hint: radioButton1.hint
                    labelVisible: false
                }
                Label {
                    title: radioButton1.title
                    hint: radioButton1.hint
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("is")
                }
                ComboBox {
                    id: switchOnOffBox
                    title: radioButton1.title
                    hint: radioButton1.hint
                    model: Constants.flagOnOffArray
                }
            }
        }

        Row {
            RadioButton {
                id: radioButton2
                text: qsTr("Variable")
                hint: qsTr("Based on the value of the specified variable.")
                exclusiveGroup: root.exclusiveGroup
                value: 1
                width: radioButtonWidth
                height: radioButtonHeight
            }
            ControlsColumn {
                enabled: radioButton2.checked
                ControlsRow {
                    GameVariableBox {
                        id: variableBox
                        title: radioButton2.title
                        hint: radioButton2.hint
                        labelVisible: false
                    }
                    ComboBox {
                        id: variableOperationBox
                        title: radioButton2.title
                        hint: radioButton2.hint
                        model: Constants.variableConditionOperatorArray
                    }
                }
                ExclusiveGroup { id: variableGroup }
                Row {
                    RadioButton {
                        id: radioButton2A
                        text: qsTr("Constant")
                        hint: qsTr("Compares with the constant value.")
                        exclusiveGroup: variableGroup
                        width: subRadioButtonWidth
                        height: radioButtonHeight
                        checked: true
                    }
                    SpinBox {
                        id: variableSpinBox
                        title: radioButton2A.title
                        hint: radioButton2A.hint
                        width: 100
                        minimumValue: -99999999
                        maximumValue: 99999999
                        enabled: radioButton2A.checked
                    }
                }
                Row {
                    RadioButton {
                        id: radioButton2B
                        text: qsTr("Variable")
                        hint: qsTr("Compares with the value of the specified variable.")
                        exclusiveGroup: variableGroup
                        width: subRadioButtonWidth
                        height: radioButtonHeight
                    }
                    GameVariableBox {
                        id: selfariableBox2
                        title: radioButton2B.title
                        hint: radioButton2B.hint
                        labelVisible: false
                        enabled: radioButton2B.checked
                    }
                }
            }
        }

        Row {
            RadioButton {
                id: radioButton3
                text: qsTr("Self Switch")
                hint: qsTr("Based on the state of the specified self switch. Vaild only in the map event.")
                exclusiveGroup: root.exclusiveGroup
                value: 2
                width: radioButtonWidth
                height: radioButtonHeight
            }
            ControlsRow {
                enabled: radioButton3.checked
                SelfSwitchBox {
                    id: selfSwitchBox
                    title: radioButton3.title
                    hint: radioButton3.hint
                    labelVisible: false
                }
                Label {
                    title: radioButton3.title
                    hint: radioButton3.hint
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("is")
                }
                ComboBox {
                    id: selfSwitchOnOffBox
                    title: radioButton3.title
                    hint: radioButton3.hint
                    model: Constants.flagOnOffArray
                }
            }
        }

        // [OneMaker MV] - Added Self Variable
        Row {
            RadioButton {
                id: radioButton5
                text: qsTr("Self Variable")
                hint: qsTr("")
                exclusiveGroup: root.exclusiveGroup
                value: 14
                width: radioButtonWidth
                height: radioButtonHeight
            }
            ControlsColumn {
                enabled: radioButton5.checked
                ControlsRow {
                    ObjComboBox {
                        id: selfVariableIdBox
                        title: radioButton5.title
                        hint: radioButton5.hint
                        model: SelfVariableNamingScheme.namingScheme
                        itemWidth: 90
                        labelVisible: false
                    }
                    ComboBox {
                        id: selfVariableOperationBox
                        title: radioButton5.title
                        hint: radioButton5.hint
                        model: Constants.variableConditionOperatorArray
                    }
                }
                ExclusiveGroup { id: selfVariableGroup }
                Row {
                    RadioButton {
                        id: radioButton5A
                        text: qsTr("Constant")
                        hint: qsTr("Compares with the constant value.")
                        exclusiveGroup: selfVariableGroup
                        width: subRadioButtonWidth
                        height: radioButtonHeight
                        checked: true
                    }
                    SpinBox {
                        id: selfVariableValueBox
                        title: radioButton5.title
                        hint: radioButton5.hint
                        width: 100
                        minimumValue: -99999999
                        maximumValue: 99999999
                        enabled: radioButton5A.checked
                    }
                }
                Row {
                    RadioButton {
                        id: radioButton5B
                        text: qsTr("Variable")
                        hint: qsTr("Compares with the value of the specified variable.")
                        exclusiveGroup: selfVariableGroup
                        width: subRadioButtonWidth
                        height: radioButtonHeight
                    }
                    GameVariableBox {
                        id: selfVariableIdBox2
                        title: radioButton5.title
                        hint: radioButton5.hint
                        labelVisible: false
                        enabled: radioButton5B.checked
                    }
                }
            }
        }

        Row {
            RadioButton {
                id: radioButton4
                text: qsTr("Timer")
                hint: qsTr("Based on the remaining time of the timer.")
                exclusiveGroup: root.exclusiveGroup
                value: 3
                width: radioButtonWidth
                height: radioButtonHeight
            }
            ControlsRow {
                enabled: radioButton4.checked
                ComboBox {
                    id: timerOperationBox
                    title: radioButton4.title
                    hint: radioButton4.hint
                    model: Constants.timerConditionOperatorArray
                }
                SpinBox {
                    id: timerSpinBox1
                    title: radioButton4.title
                    hint: radioButton4.hint
                    width: 100
                    minimumValue: 0
                    maximumValue: 99
                    suffix: " " + qsTr("min")
                }
                SpinBox {
                    id: timerSpinBox2
                    title: radioButton4.title
                    hint: radioButton4.hint
                    width: 100
                    minimumValue: 0
                    maximumValue: 59
                    suffix: " " + qsTr("sec")
                }
            }
        }

        Component.onCompleted: root._column = this

        function loadParameters(params) {
            switch (params[0]) {
            case 0:     // Switch
                radioButton1.checked = true;
                switchBox.switchId = params[1];
                switchOnOffBox.currentIndex = params[2];
                break;
            case 1:     // Variable
                radioButton2.checked = true;
                variableBox.variableId = params[1];
                if (params[2] === 0) {
                    radioButton2A.checked = true;
                    variableSpinBox.value = params[3];
                } else {
                    radioButton2B.checked = true;
                    variableBox2.variableId = params[3];
                }
                variableOperationBox.currentIndex = params[4];
                break;
            case 2:     // Self Switch
                radioButton3.checked = true;
                selfSwitchBox.setCharacter(params[1]);
                selfSwitchOnOffBox.currentIndex = params[2];
                break;
            case 3:     // Timer
                radioButton4.checked = true;
                timerSpinBox1.value = Math.floor(params[1] / 60);
                timerSpinBox2.value = Math.floor(params[1] % 60);
                timerOperationBox.currentIndex = params[2];
                break;
            case 14: // [OneMaker MV] - Added Self Variables
                radioButton5.checked = true;
                selfVariableIdBox.currentIndex = params[1] - 1;
                if (params[2] === 0) {
                    radioButton5A.checked = true;
                    selfVariableValueBox.value = params[3];
                }
                else {
                    radioButton5B.checked = true;
                    selfVariableIdBox2.variableId = params[3];
                }
                selfVariableOperationBox.currentIndex = params[4];
                break;
            }
        }

        function makeParameters() {
            var params = [];
            var type = root.exclusiveGroup.current.value;
            params[0] = type;
            switch (type) {
            case 0:     // Switch
                params[1] = switchBox.switchId;
                params[2] = switchOnOffBox.currentIndex;
                break;
            case 1:     // Variable
                params[1] = variableBox.variableId;
                if (radioButton2A.checked) {
                    params[2] = 0;
                    params[3] = variableSpinBox.value;
                } else {
                    params[2] = 1;
                    params[3] = variableBox2.variableId;
                }
                params[4] = variableOperationBox.currentIndex;
                break;
            case 2:     // Self Switch
                params[1] = selfSwitchBox.currentCharacter;
                params[2] = selfSwitchOnOffBox.currentIndex;
                break;
            case 3:     // Timer
                params[1] = timerSpinBox1.value * 60 + timerSpinBox2.value;
                params[2] = timerOperationBox.currentIndex;
                break;
            case 14: // [OneMaker MV] - Added Self Variables
                params[1] = selfVariableIdBox.value;
                if (radioButton5A.checked) {
                    params[2] = 0;
                    params[3] = selfVariableValueBox.value;
                }
                else {
                    params[2] = 2;
                    params[3] = selfVariableIdBox2.variableId;
                }
                params[4] = selfVariableOperationBox.currentIndex;
                break;
            }
            return params;
        }
    }

    function loadParameters(params) {
        _column.loadParameters(params);
    }

    function makeParameters() {
        return _column.makeParameters();
    }
}
