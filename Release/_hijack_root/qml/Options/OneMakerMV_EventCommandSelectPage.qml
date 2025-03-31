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
    title: qsTr("Event Command Select Settings")

    property bool currentState: OneMakerMVSettings.getSetting("eventCommandSelect", "combinedEnabled")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        GroupBox {
            height: 50
            width: 240
            CheckBox {
                text: qsTr("Combine Command Select Tabs")
                hint: qsTr("")
                y: -10
                checked: currentState

                onCheckedChanged: {
                    if (currentState != checked) {
                        if (currentState) {
                            OneMakerMVSettings.setSetting("eventCommandSelect", "combinedEnabled", false)
                            OneMakerMVSettings.setSetting("eventCommandSelect", "width", 508)
                        }
                        else {
                            OneMakerMVSettings.setSetting("eventCommandSelect", "combinedEnabled", true)
                            OneMakerMVSettings.setSetting("eventCommandSelect", "width", 1758)
                        }
                        currentState = checked
                    }                        
                }
            }
        }
    }
}