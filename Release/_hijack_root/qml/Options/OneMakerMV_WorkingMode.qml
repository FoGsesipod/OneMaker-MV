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
    title: qsTr("Working Mode")

    property bool expectedContextCurrentState: OneMakerMVSettings.getSetting("workingMode", "expectedContext")
    property bool faceImageCurrentState: OneMakerMVSettings.getSetting("workingMode", "faceImageBoxChange")
    property bool actionPatternsCurrentState: OneMakerMVSettings.getSetting("workingMode", "removeActionPatterns")
    property bool textPreviewFontCurrentState: OneMakerMVSettings.getSetting("workingMode", "changeTextPreviewFont")
    property bool customEventCommandsCurrentState: OneMakerMVSettings.getSetting("workingMode", "customEventCommands")

    DialogBox {
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true

        ControlsColumn {
            GroupBox {
                width: 550
                height: 100
                ControlsColumn {
                    spacing: 20
                    Label {
                        text: qsTr("These settings are for disabling specific changes that might harm functionality of\nthe editor when using OneMaker MV for projects outside of OMORI modding.\nDisabling 'Expected Context' will disable all of these settings.")
                    }
                    CheckBox {
                        id: expectedContextCheckBox
                        text: qsTr("Expected Context")
                        hint: qsTr("")
                        checked: expectedContextCurrentState

                        onCheckedChanged: {
                            if (expectedContextCurrentState != checked) {
                                if (expectedContextCurrentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "expectedContext", false);
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "expectedContext", true);
                                }
                                expectedContextCurrentState = checked;
                            }
                        }
                    }
                }
            }
            GroupBox {
                width: 550
                height: 550
                ControlsColumn {
                    y: -15
                    spacing: 5
                    enabled: expectedContextCheckBox.checked
                    Label {
                        text: qsTr("Face Image Selection Size Reduction")
                    }
                    CheckBox {
                        text: qsTr("106 x 106 Face Size")
                        hint: qsTr("")
                        checked: faceImageCurrentState

                        onCheckedChanged: {
                            if (faceImageCurrentState != checked) {
                                if (faceImageCurrentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "faceImageBoxChange", false);
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "faceImageBoxChange", true);
                                }
                                faceImageCurrentState = checked;
                            }
                        }
                    }
                    Label {
                        text: qsTr("Remove Action Patterns")
                    }
                    CheckBox {
                        text: qsTr("Bigger Enemy Note Box")
                        hint: qsTr("")
                        checked: actionPatternsCurrentState

                        onCheckedChanged: {
                            if (actionPatternsCurrentState != checked) {
                                if (actionPatternsCurrentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "removeActionPatterns", false);
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "removeActionPatterns", true);
                                }
                                actionPatternsCurrentState = checked;
                            }
                        }
                    }
                    Label {
                        text: qsTr("Change Text Preview Font")
                    }
                    CheckBox {
                        text: qsTr("Use OMORI's Font")
                        hint: qsTr("")
                        checked: textPreviewFontCurrentState

                        onCheckedChanged: {
                            if (textPreviewFontCurrentState != checked) {
                                if (textPreviewFontCurrentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "changeTextPreviewFont", false);
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "changeTextPreviewFont", true);
                                }
                                textPreviewFontCurrentState = checked;
                            }
                        }
                    }
                    Label {
                        text: qsTr("Show OMORI Specific Custom Event Commands")
                    }
                    CheckBox {
                        text: qsTr("OMORI Custom Commands")
                        hint: qsTr("")
                        checked: customEventCommandsCurrentState

                        onCheckedChanged: {
                            if (customEventCommandsCurrentState != checked) {
                                if (customEventCommandsCurrentState) {
                                    OneMakerMVSettings.setSetting("workingMode", "customEventCommands", false);
                                }
                                else {
                                    OneMakerMVSettings.setSetting("workingMode", "customEventCommands", true);
                                }
                                customEventCommandsCurrentState = checked;
                            }
                        }
                    }
                }
            }
        }
    }
}