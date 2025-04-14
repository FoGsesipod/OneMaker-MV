import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"

ModalWindow {
    id: root

    title: qsTr("Select an Effect")

    property string seName: ""

    property var model: [];

    DialogBox {
        applyVisible: false

        ObjComboBox {
            id: comboBox
            title: qsTr("Effect Name")
            hint: qsTr("")
            model: root.model
            currentIndex: model.indexOf(root.seName)
        }

        onOk: {
            root.seName = comboBox.model[comboBox.currentIndex];
        }
    }
}