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

    readonly property bool rangeMode: radioButton2.checked

    readonly property int startId: {
        return rangeMode ? Math.min(spinBox1.value, spinBox2.value) : selfVariableBox.value;
    }
    readonly property int endId: {
        return rangeMode ? Math.max(spinBox1.value, spinBox2.value) : selfVariableBox.value;
    }

    property int radioButtonWidth: 100
    property int itemHeight: 28

    ControlsColumn {
        ExclusiveGroup { id: group }

        ControlsRow {
            RadioButton {
                id: radioButton1
                text: qsTr("Single")
                hint: qsTr("Operates one self variable.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
                checked: true
            }
            ObjComboBox {
                id: selfVariableBox
                title: radioButton1.title
                hint: radioButton1.hint
                model: SelfVariableNamingScheme.namingScheme
                enabled: radioButton1.checked
                labelVisible: false
            }
        }

        ControlsRow {
            RadioButton {
                id: radioButton2
                text: qsTr("Range")
                hint: qsTr("Operates all self variables found between two specified numbers.")
                exclusiveGroup: group
                width: root.radioButtonWidth
                height: root.itemHeight
            }
            SpinBox {
                id: spinBox1
                title: radioButton2.title
                hint: radioButton2.hint
                enabled: radioButton2.checked
                minimumValue: 1
                maximumValue: 10
            }
            Label {
                text: "~"
                anchors.verticalCenter: parent.verticalCenter
                title: radioButton2.title
                hint: radioButton2.hint
                enabled: radioButton2.checked
            }
            SpinBox {
                id: spinBox2
                title: radioButton2.title
                hint: radioButton2.hint
                enabled: radioButton2.checked
                minimumValue: 1
                maximumValue: 10
            }
        }
    }

    function setup(startId, endId) {
        if (startId === endId) {
            radioButton1.checked = true;
        } else {
            radioButton2.checked = true;
        }
        selfVariableBox.currentIndex = startId;
        spinBox1.value = startId;
        spinBox2.value = endId;
    }
}
