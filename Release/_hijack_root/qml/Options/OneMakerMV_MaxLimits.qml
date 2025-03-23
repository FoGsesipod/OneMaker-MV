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
    title: qsTr("Max Limit Settings");

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        GroupBox {
            height: 55
            width: 150
            LabeledSpinBox {
                title: qsTr("Max Level")
                hint: qsTr("")
                minimumValue: 1
                maximumValue: 10000
                value: OneMakerMVSettings.getSetting("maxLevel", "maximun")
                itemWidth: 80
                y: -25
                
                onValueChanged: {
                    OneMakerMVSettings.setSetting("maxLevel", "maximun", value)
                }
            }
        }
    }
}