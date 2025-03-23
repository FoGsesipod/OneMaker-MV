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
    title: qsTr("Window Size Settings")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        ControlsColumn {
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Default Window Height Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "defaultHeightIncrease")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "defaultHeightIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 200\nDefault 720p: 100")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Default Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "defaultWidthIncrease")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "defaultWidthIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 200\nDefault 720p: 100")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Alternative Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "alternativeHeightIncrease")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "alternativeHeightIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 100\nDefault 720p: 80")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Alternative Window Width Increase")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "alternativeWidthIncrease")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "alternativeWidthIncrease", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 100\nDefault 720p: 80")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Animation Timings ListBox Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupAnimationTimingsListBoxWidth")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupAnimationTimingsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 298\nDefault 720p: 282")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Note Database Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseWidth")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupNoteDatabaseWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default 1080p: 940\nDefault 720p: 920")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Note Database X")
                        hint: qsTr("")
                        minimumValue: -1000
                        maximumValue: 0
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseX")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupNoteDatabaseX", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: -420")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Effects ListBox Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupEffectsListBoxWidth")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupEffectsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 116")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Group Traits List Box Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "groupTraitsListBoxWidth")
                        width: 290
                        itemWidth: 80
                        y: -25

                            onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "groupTraitsListBoxWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 116")
                        height: 20
                        y: -13
                    }
                }
            }
            GroupBox {
                height: 55
                width: 450
                ControlsRow {
                    LabeledSpinBox {
                        title: qsTr("Layout Event Editor Note Width")
                        hint: qsTr("")
                        minimumValue: 0
                        maximumValue: 1000
                        value: OneMakerMVSettings.getSetting("windowSizes", "layoutEventEditorNoteWidth")
                        width: 290
                        itemWidth: 80
                        y: -25

                        onValueChanged: {
                            OneMakerMVSettings.setSetting("windowSizes", "layoutEventEditorNoteWidth", value)
                        }
                    }
                    Label {
                        text: qsTr("Default: 460")
                        height: 20
                        y: -13
                    }
                }
            }
        }
    }
}