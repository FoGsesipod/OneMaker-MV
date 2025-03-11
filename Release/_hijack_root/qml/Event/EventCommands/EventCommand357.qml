import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

EventCommandBase {
    Group_SelfVariableRange {
        id: rangeGroup
        title: qsTr("Self Variable")
        hint: qsTr("Self Variable(s) to operate")
    }

    GroupBox {
        id: operationGroup
        title: qsTr("Operation")
        hint: qsTr("Operation to run on the specified variable(s).")

        readonly property int operationType: operationButtonGroup.current.value

        ControlsRow {
            ExclusiveGroup { id: operationButtonGroup }

            property int radioButtonWidth: 60

            RadioButton {
                id: radioButtonA1
                text: qsTr("Set", "Set to the variable")
                hint: qsTr("Stores the operand to the specified variable(s).")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 0
                checked: true
            }

            RadioButton {
                id: radioButtonA2
                text: qsTr("Add", "Add to the variable")
                hint: qsTr("Adds the operand to the specified variable(s).")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 1
            }

            RadioButton {
                id: radioButtonA3
                text: qsTr("Sub", "Subtract")
                hint: qsTr("Subtracts the operand from the specified variable(s).")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 2
            }

            RadioButton {
                id: radioButtonA4
                text: qsTr("Mul", "Multiply")
                hint: qsTr("Multiplies the specified variable(s) by the operand.")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 3
            }

            RadioButton {
                id: radioButtonA5
                text: qsTr("Div", "Divide")
                hint: qsTr("Divides the specified variable(s) by the operand.")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 4
            }

            RadioButton {
                id: radioButtonA6
                text: qsTr("Mod", "Modulo")
                hint: qsTr("Divides the specified variable(s) by the operand and stores the remainder(s).")
                exclusiveGroup: operationButtonGroup
                width: parent.radioButtonWidth
                value: 5
            }
        }

        function setup(operationType) {
            switch (operationType) {
            case 0:
                radioButtonA1.checked = true;
                break;
            case 1:
                radioButtonA2.checked = true;
                break;
            case 2:
                radioButtonA3.checked = true;
                break;
            case 3:
                radioButtonA4.checked = true;
                break;
            case 4:
                radioButtonA5.checked = true;
                break;
            case 5:
                radioButtonA6.checked = true;
                break;
            }
        }
    }

    Group_Operand {
        id: operandGroup
        title: qsTr("Operand")
        hint: qsTr("Value to be used in calculating variables.")
        full: true
        troopId: root.troopId
        minimumValue: -99999999
        maximumValue: 99999999
    }

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            rangeGroup.setup(params[0], params[1]);
            operationGroup.setup(params[2]);
            operandGroup.setup(params[3], params[4], params[5], params[6]);
        }
    }

    onSave: {
        if (!eventData) {
            makeSimpleEventData();
        }
        var params = eventData[0].parameters;
        params.length = 0;
        params[0] = rangeGroup.startId;
        params[1] = rangeGroup.endId;
        params[2] = operationGroup.operationType;
        Array.prototype.push.apply(params, operandGroup.makeFullOperandParams());
    }
}
