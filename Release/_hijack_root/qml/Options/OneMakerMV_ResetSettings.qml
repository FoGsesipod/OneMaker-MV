import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root
    title: qsTr("Reset Settings to Default")

    DialogBox {
        id: dialog
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        GroupBox {
            width: 300
            height: 75
            ControlsColumn {
                y: -15
                Label {
                    text: qsTr("Reset OneMaker MV's settings to default?")
                }
                Button {
                    text: qsTr("Yes, Reset my Settings")
                    onClicked: OneMakerMVSettings.resetSettings(), dialog.cancel()
                }
            }
        }
    }
}