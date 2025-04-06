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
    title: qsTr("Window Size Settings")

    property bool disableCurrentState: OneMakerMVSettings.getSetting("windowSizes", "globalDisable")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        ControlsColumn {
            GroupBox {
                width: 650
                height: 65
                ControlsRow {
                    ControlsColumn {
                        width: 175
                        y: -23
                        Label {
                            text: qsTr("Resolution Below 900p:")
                        }
                        CheckBox {
                            id: checkBox
                            text: qsTr("Global Disable")
                            hint: qsTr("")
                            checked: disableCurrentState
                            
                            onCheckedChanged: {
                                if (disableCurrentState != checked) {
                                    if (disableCurrentState) {
                                        OneMakerMVSettings.setSetting("windowSizes", "globalDisable", false)
                                    }
                                    else {
                                        OneMakerMVSettings.setSetting("windowSizes", "globalDisable", true)
                                    }
                                    disableCurrentState = checked
                                }
                            }
                        }
                    }
                    Label {
                        text: qsTr("This will disable all OneMaker MV window size modifications. Including\nthe hardcoded `Default Window Height` minimun of 100. As a result,\nSelf Variable and Script Event Page Conditions will also be disabled.")
                        y: -5
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Default Window Height Increase")
                        hint: qsTr("")
                        minimumValue: 100
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "defaultHeightIncrease")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "defaultHeightIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 200\nDefault 900p: 100")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 100\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Default Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "defaultWidthIncrease")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "defaultWidthIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 200\nDefault 900p: 100")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Alternative Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "alternativeHeightIncrease")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "alternativeHeightIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 100\nDefault 900p: 80")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Alternative Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "alternativeWidthIncrease")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "alternativeWidthIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 100\nDefault 900p: 80")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Animation Timings ListBox Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupAnimationTimingsListBoxWidth")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupAnimationTimingsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 298\nDefault 900p: 282")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Note Database Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseWidth")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupNoteDatabaseWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 620\nDefault 900p: 600")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Note Database X")
                        hint: qsTr("")
                        minimumValue: -1000
                        maximumValue: 0
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseX")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupNoteDatabaseX", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: -420\n ")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: -1000\nMax Value: 0")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Effects ListBox Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupEffectsListBoxWidth")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupEffectsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 116\n ")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Traits List Box Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupTraitsListBoxWidth")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupTraitsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 116\n ")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
            GroupBox {
                width: 650
                height: 55
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Layout Event Editor Note Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "layoutEventEditorNoteWidth")
                        width: 385
                        itemWidth: 80
                        y: -25
                        enabled: !checkBox.checked

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "layoutEventEditorNoteWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 460\n ")
                        width: 125
                        height: 20
                        y: -14
                    }
                    Label {
                        text: qsTr("Min Value: 0\nMax Value: 1000")
                        height: 20
                        y: -14
                    }
                }
            }
        }
    }
}