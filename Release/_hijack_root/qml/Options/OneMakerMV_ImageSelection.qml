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
    title: qsTr("Image Selection")

    property var currentSelection: OneMakerMVSettings.getSetting("imagePack", "arrayIndex")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

            ControlsColumn {
                GroupBox {
                height: 55
                width: 250
                LabeledComboBox {
                    title: qsTr("Image Pack - Changes on Restart")
                    hint: qsTr("")
                    model: ["Default", "MZ", "Koffin", "Krypt"]
                    currentIndex: currentSelection
                    itemWidth: 100
                    y: -25
    
                    onCurrentIndexChanged: {
                        if (currentSelection != currentIndex) {
                            OneMakerMVSettings.setSetting("imagePack", "userSelection", currentText)
                            OneMakerMVSettings.setSetting("imagePack", "arrayIndex", currentIndex)
                            currentSelection = currentIndex
                        }
                    }
                }
            }
        }
    }
}