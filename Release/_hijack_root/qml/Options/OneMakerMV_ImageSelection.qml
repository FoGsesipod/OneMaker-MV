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
    title: qsTr("Image Selection")

    property var currentSelection: OneMakerMVSettings.getSetting("imagePack", "arrayIndex")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        ControlsColumn {
            GroupBox {
                height: 95
                width: 285
                LabeledComboBox {
                    title: qsTr("Image Pack - Changes on Restart")
                    hint: qsTr("")
                    model: ["Default", "MZ", "Koffin", "Krypt", "Custom"]
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
                Label {
                    text: qsTr("The Custom Selection is for custom packs.\nBy default it contains no images.")
                    y: 35
                }
            }
        }
    }
}