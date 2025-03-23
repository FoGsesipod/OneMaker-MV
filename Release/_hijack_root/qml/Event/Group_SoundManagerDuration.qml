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

    ControlsRow {
        LabeledSpinBox {
            id: spinBox
            title: root.title
            hint: root.hint
            minimumValue: 0
            maximumValue: 99999
            value: 60
            itemWidth: 80
            labelVisible: false
        }
        Label {
            id: unitLabel
            title: root.title
            hint: root.hint
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("seconds")
        }
    }
}
