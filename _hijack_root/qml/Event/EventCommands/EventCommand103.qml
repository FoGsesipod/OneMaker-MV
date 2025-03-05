import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Input Number
EventCommandBase {
    id: root

    GameVariableBox {
        id: variableBox
        title: qsTr("Variable")
        hint: qsTr("Variable containing the numeric value entered by the player. The original entry is displayed in this variable as entry begins.")
    }

    LabeledSpinBox {
        id: spinBox
        title: qsTr("Digits")
        hint: qsTr("Number of digits to be entered.")
        minimumValue: 1
        maximumValue: 9
        value: 1
    }

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            variableBox.variableId = params[0];
            spinBox.value = params[1];
        }
    }

    onSave: {
        if (!eventData) {
            makeSimpleEventData();
        }
        var params = eventData[0].parameters;
        params[0] = variableBox.variableId;
        params[1] = spinBox.value;
    }
}
