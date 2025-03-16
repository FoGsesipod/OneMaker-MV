import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Singletons"

ControlsRow {
    id: root

    signal nameModified()

    property var searchableFields: ([
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the actor.") },
        { name: "nickname", title: qsTr("Nickname"), hint: qsTr("Nickname displayed on the status screen.") },
        { name: "profile", title: qsTr("Profile"), hint: qsTr("Text to be displayed on the status screen.") },
        { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc },
    ])

    GroupBoxColumn {
        GroupBox {
            id: generalSettings
            title: qsTr("General Settings")
            hint: qsTr("Basic actor settings.")
            ControlsColumn {
                ControlsRow {
                    ObjTextField {
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the actor.")
                        onModified: nameModified()
                    }
                    ObjTextField {
                        member: "nickname"
                        title: qsTr("Nickname")
                        hint: qsTr("Nickname displayed on the status screen. Can be left empty.")
                    }
                }
                ControlsRow {
                    GameObjectBox {
                        member: "classId"
                        title: qsTr("Class")
                        hint: qsTr("Class of the actor.")
                        dataSetName: "classes"
                        onCurrentIdChanged: {
                            equipmentList.refresh();
                        }
                    }
                    ObjSpinBox {
                        id: initialLevel
                        member: "initialLevel"
                        title: qsTr("Initial Level")
                        hint: qsTr("Level at the start of the game.")
                        minimumValue: 1
                        maximumValue: MaxLevel.maximun // [OneMaker MV] - Change to use MaxLevel's value
                    }
                    ObjSpinBox {
                        id: maxLevel
                        member: "maxLevel"
                        title: qsTr("Max Level")
                        hint: qsTr("Maximum level that the actor can attain.")
                        minimumValue: 1
                        maximumValue: MaxLevel.maximun // [OneMaker MV] - Change to use MaxLevel's value
                    }
                }
                ObjTextArea {
                    member: "profile"
                    title: qsTr("Profile")
                    hint: qsTr("Text to be displayed on the status screen. Enter information such as the character's profile.")
                }
            }
        }
        GroupBox {
            title: qsTr("Images")
            hint: qsTr("Images of the actor to be displayed in the game.")
            width: generalSettings.width
            ControlsRow {
                FaceImageBox {
                    memberForName: "faceName"
                    memberForIndex: "faceIndex"
                    title: Constants.faceImageTitle
                    hint: Constants.faceImageHint
                }
                CharacterImageBox {
                    memberForName: "characterName"
                    memberForIndex: "characterIndex"
                    title: Constants.characterImageTitle
                    hint: Constants.characterImageHint
                    itemWidth: 104
                    itemHeight: 104
                }
                SvActorImageBox {
                    memberForName: "battlerName"
                    title: Constants.battlerImageTitle
                    hint: Constants.battlerImageHint
                }
            }
        }
        GroupBox {
            id: equipGroup
            title: qsTr("Initial Equipment")
            hint: qsTr("Weapon and armor that the actor has equipped at the start of the game.")
            width: generalSettings.width
            ControlsColumn {
                EquipmentListBox {
                    id: equipmentList
                    member: "equips"
                    title: equipGroup.title
                    hint: equipGroup.hint
                    width: 390
                    height: 206 + WindowSizes.defaultHeightIncrease // [OneMaker MV] - Window Increased
                }
            }
        }
    }
    GroupBoxColumn {
        Group_Traits {
        }
        Group_Note {
        }
    }
}
