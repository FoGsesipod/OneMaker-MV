import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root

    title: qsTr("SE and Flash Timing")

    property int maxFrames: 1
    property var dataObject: null;

    // [OneMaker MV] - Store Aries Plugin Status
    property bool ariesPluginDetected: OneMakerMVSettings.detectPluginActivationStatus("Aries001_AnimationScreenEffects")

    // [OneMaker MV] - Create Aries Tab data for dynamic adding
    Component {
        id: ariesTabComponent
            TabColumn {
                GroupBoxRow {
                    visible: ariesPluginDetected
                    GroupBox {
                        id: frameGroup
                        title: qsTr("Frame")
                        hint: qsTr("Frame number to associate this data.")
                        ObjSpinBox {
                            id: frameSpinBox
                            member: "frame"
                            title: frameGroup.title
                            hint: frameGroup.hint
                            labelVisible: false
                            minimumValue: 1
                            maximumValue: maxFrames
                            valueOffset: -1
                        }
                    }
                    GroupBox {
                        id: seGroup
                        title: qsTr("Effect")
                        hint: qsTr("Aries SE Effect to use.")
                        ObjAriesSeEffects {
                            id: seBox
                            member: "se"
                            title: seGroup.title
                            hint: seGroup.hint
                            labelVisible: false
                            allowNull: true
                        }
                    }
                }
                GroupBox {
                    title: qsTr("Effect Settings")
                    hint: qsTr("The effects settings.")
                    width: 440
                    visible: ariesPluginDetected
    
                    ControlsColumn {
                        ControlsRow {
                            ExclusiveGroup { id: group }
                            spacing: 20
    
                            ObjRadioButton {
                                id: radioButton1
                                member: "flashScope"
                                text: qsTr("Target")
                                hint: qsTr("Flashes the animation target.")
                                index: 1
                                exclusiveGroup: group
                                KeyNavigation.right: radioButton2
                            }
                            ObjRadioButton {
                                id: radioButton2
                                member: "flashScope"
                                text: qsTr("Screen")
                                hint: qsTr("Flashes the entire screen.")
                                index: 2
                                exclusiveGroup: group
                                KeyNavigation.right: radioButton3
                            }
                            ObjRadioButton {
                                id: radioButton3
                                member: "flashScope"
                                text: qsTr("Hide Target")
                                hint: qsTr("Hides the target for a given time.")
                                index: 3
                                exclusiveGroup: group
                                KeyNavigation.right: radioButton1
                            }
                        }
    
                        Item {
                            width: 2
                            height: 8
                        }
    
                        Layout_AriesSESettings {
                            member: "flashColor"
                            dataObject: root.dataObject
                            seName: seBox.text
                        }
    
                        Item {
                            width: 2
                            height: 2
                        }
    
                        ObjSpinBox {
                            id: durationSpinBox
                            member: "flashDuration"
                            title: qsTr("Duration")
                            hint: qsTr("Duration of the effect.")
                            horizontal: true
                            minimumValue: 1
                            maximumValue: 200
                        }
                    }
                }
            }
        }

    DialogBox {
        applyVisible: false
        // [OneMaker MV] - Add Tab View for intuitiveness
        TabView {
            id: tabView
            width: 465
            height: 335

            Tab {
                title: qsTr("Normal")
                TabColumn { // [OneMaker MV] - Change to TabColumn 
                    GroupBoxRow {
                        GroupBox {
                            id: frameGroup
                            title: qsTr("Frame")
                            hint: qsTr("Frame number to associate this data.")
                            ObjSpinBox {
                                id: frameSpinBox
                                member: "frame"
                                title: frameGroup.title
                                hint: frameGroup.hint
                                labelVisible: false
                                minimumValue: 1
                                maximumValue: maxFrames
                                valueOffset: -1
                            }
                        }
                        GroupBox {
                            id: seGroup
                            title: qsTr("SE")
                            hint: qsTr("Sound effect to play at the specified frame.")
                            ObjAudioBox {
                                id: seBox
                                member: "se"
                                title: seGroup.title
                                hint: seGroup.hint
                                labelVisible: false
                                subFolder: "se"
                                allowNull: true
                            }
                        }
                    }

                    GroupBox {
                        title: qsTr("Flash")
                        hint: qsTr("Flash effect to play at the specified frame.")
                        width: 440

                        ControlsColumn {
                            ControlsRow {
                                ExclusiveGroup { id: group }
                                spacing: 20

                                ObjRadioButton {
                                    id: radioButton1
                                    member: "flashScope"
                                    text: qsTr("None")
                                    hint: qsTr("No flash effect.")
                                    index: 0
                                    exclusiveGroup: group
                                    KeyNavigation.right: radioButton2
                                }
                                ObjRadioButton {
                                    id: radioButton2
                                    member: "flashScope"
                                    text: qsTr("Target")
                                    hint: qsTr("Flashes the animation target.")
                                    index: 1
                                    exclusiveGroup: group
                                    KeyNavigation.right: radioButton3
                                }
                                ObjRadioButton {
                                    id: radioButton3
                                    member: "flashScope"
                                    text: qsTr("Screen")
                                    hint: qsTr("Flashes the entire screen.")
                                    index: 2
                                    exclusiveGroup: group
                                    KeyNavigation.right: radioButton4
                                }
                                ObjRadioButton {
                                    id: radioButton4
                                    member: "flashScope"
                                    text: qsTr("Hide Target")
                                    hint: qsTr("Hides the target for a given time.")
                                    index: 3
                                    exclusiveGroup: group
                                    KeyNavigation.right: radioButton1
                                }
                            }

                            Item {
                                width: 2
                                height: 8
                            }

                            Layout_FlashColor {
                                member: "flashColor"
                                dataObject: root.dataObject
                                enabled: radioButton2.checked || radioButton3.checked
                            }

                            Item {
                                width: 2
                                height: 2
                            }

                            ObjSpinBox {
                                id: durationSpinBox
                                member: "flashDuration"
                                title: qsTr("Duration")
                                hint: qsTr("Duration of the flash in 1/15 seconds.")
                                enabled: !radioButton1.checked
                                horizontal: true
                                minimumValue: 1
                                maximumValue: 200
                            }
                        }
                    }
                }
            }

            // [OneMaker MV] - Workaround to make the tab not appear if the plugin isn't installed.
            Component.onCompleted: {
                timer.start();
            }

            Timer {
                id: timer
                interval: 1
                repeat: false
                running: false
                onTriggered: {
                    tabView.updateAriesTab()
                }
            }

            function updateAriesTab() {
                if (root.ariesPluginDetected) {
                    console.log("Current tab count:", tabView.count);
                    var ariesTabInstance = tabView.insertTab(tabView.count, qsTr("Aries001"), ariesTabComponent);
                }
            }
        }
    }
}