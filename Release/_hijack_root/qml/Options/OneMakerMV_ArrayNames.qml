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

    property bool selfSwitchCurrentState: OneMakerMVSettings.getSetting("selfSwitchNaming", "enabled")

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
                CheckBox {
                    id: checkBox
                    text: textField2.title
                    hint: textField2.hint
                    y: 5
                    checked: selfSwitchCurrentState

                    onCheckedChanged: {
                        if (selfSwitchCurrentState != checked) {
                            if (selfSwitchCurrentState) {
                                OneMakerMVSettings.setSetting("selfSwitchNaming", "enabled", false)
                                OneMakerMVSettings.setSetting("selfSwitchNaming", "namingScheme", OneMakerMVSettings.defaultSettings["selfSwitchNaming"]["namingScheme"])
                                textField2.text = OneMakerMVSettings.getArraySetting("selfSwitchNaming", "namingScheme");
                            }
                            else {
                                OneMakerMVSettings.setSetting("selfSwitchNaming", "enabled", true)
                            }
                            selfSwitchCurrentState = checked
                        }
                    }
                }
                Label {
                    text: qsTr("Self Switch Naming Scheme")
                    y: -20
                }
                TextField {
                    id: textField2
                    title: qsTr("Self Switch Naming Scheme")
                    hint: qsTr("Self Switches use Text, not Id's.\nThis means that changing them from the default will change how you write script commands.\n\nChanging this is especially not recommended for multi-programmer projects.")
                    text: OneMakerMVSettings.getArraySetting("selfSwitchNaming", "namingScheme");
                    width: 480
                    x: 20
                    selectAllOnFocus: false
                    enabled: checkBox.checked
                }
                Label {
                    title: textField2.title
                    hint: textField2.hint
                    text: qsTr("Please View The ToolTip")
                    y: 28
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
                    id: textField3
                    text: OneMakerMVSettings.getArraySetting("soundSlotNaming", "namingScheme");
                    width: 500
                    selectAllOnFocus: false
                }
            }
        }

        onOk: {
            OneMakerMVSettings.setArraySetting("selfVariableNaming", "namingScheme", textField1.text)
            OneMakerMVSettings.setArraySetting("selfSwitchNaming", "namingScheme", textField2.text)
            OneMakerMVSettings.setArraySetting("soundSlotNaming", "namingScheme", textField3.text)
        }
    }
}