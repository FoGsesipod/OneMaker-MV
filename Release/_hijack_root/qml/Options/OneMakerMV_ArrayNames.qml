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
    title: qsTr("Array Naming")

    DialogBox {
        okVisible: true
        cancelVisible: false
        applyVisible: false
        closeVisible: false

        ControlsColumn {
            GroupBox {
                height: 75
                width: 525
                Label {
                    text: qsTr("Self Variable Naming Scheme:")
                    y: -20
                }
                TextField {
                    id: textField1
                    text: OneMakerMVSettings.getArraySetting("selfVariableNaming", "namingScheme");
                    width: 500
                    selectAllOnFocus: false
                }
            }
            GroupBox {
                height: 75
                width: 525
                Label {
                    text: qsTr("Sound Slot Naming Scheme: ")
                    y: -20
                }
                TextField {
                    id: textField2
                    text: OneMakerMVSettings.getArraySetting("soundSlotNaming", "namingScheme");
                    width: 500
                    selectAllOnFocus: false
                }
            }
        }

        onOk: {
            OneMakerMVSettings.setArraySetting("selfVariableNaming", "namingScheme", textField1.text)
            OneMakerMVSettings.setArraySetting("soundSlotNaming", "namingScheme", textField2.text)
        }
    }
}