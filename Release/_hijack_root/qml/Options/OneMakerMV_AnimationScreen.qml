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
    title: qsTr("Animation Screen")

    property var currentSelection: OneMakerMVSettings.getSetting("animationScreenBlendMode", "default")

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
                    title: qsTr("Default New Cell Blend Mode")
                    hint: qsTr("")
                    model: Constants.blendModeArray
                    currentIndex: currentSelection
                    itemWidth: 100
                    y: -25
    
                    onCurrentIndexChanged: {
                        if (currentSelection != currentIndex) {
                            OneMakerMVSettings.setSetting("animationScreenBlendMode", "default", currentIndex)
                            currentSelection = currentIndex
                        }
                    }
                }
            }
        }
    }
}