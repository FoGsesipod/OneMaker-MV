import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

ModalWindow {
    id: root
    title: qsTr("Working Mode")

    property bool currentState: OneMakerMVSettings.getSetting("workingMode", "expectedContext")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        GroupBox {
            height: 100
            width: 550
            ControlsColumn {
                Label {
                    text: qsTr("This setting is for disabling OMORI specific editor changes.\nIf you are using OneMaker MV for other projects then OMORI Modding, disable this.")
                }
                Item {
                    CheckBox {
                        text: qsTr("Expected Context")
                        hint: qsTr("")
                        y: 35
                        checked: currentState

                        onCheckedChanged: {
                            if (currentState != checked) {
                                if (currentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "expectedContext", false)
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "expectedContext", true)
                                }
                                currentState = checked
                            }
                        }
                    }
                }
            }
        }
    }
}