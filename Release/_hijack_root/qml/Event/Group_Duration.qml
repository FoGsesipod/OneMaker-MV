import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"

GroupBox {
    id: root

    title: qsTr("Duration")
    hint: qsTr("Duration of the effect in frames.")

    property alias unit: unitLabel.text
    property alias value: spinBox.value
    property alias waitVisible: checkBox.visible
    property alias waitChecked: checkBox.checked

    ControlsRow {
        LabeledSpinBox {
            id: spinBox
            title: root.title
            hint: root.hint
            minimumValue: 1
            maximumValue: 99999 // [OneMaker MV] - Changed to 99999 from 999
            value: 60
            itemWidth: 80
            labelVisible: false
        }
        Label {
            id: unitLabel
            title: root.title
            hint: root.hint
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("frames (1/60 sec)")
        }
        Item {
            width: 4
            height: 1
            visible: checkBox.visible
        }
        CheckBox {
            id: checkBox
            text: qsTr("Wait for Completion")
            hint: qsTr("Waits for the effect to finish.")
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            checked: true
        }
        Item {
            width: 4
            height: 1
            visible: checkBox.visible
        }
    }
}
