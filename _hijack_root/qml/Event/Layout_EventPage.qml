import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

GroupBoxRow {
    id: root

    property var dataObject
    property int mapId: 0

    GroupBoxColumn {
        Group_EventConditions {
            id: conditionsGroup
            width: imageAndMovement.width
        }

        GroupBoxRow {
            id: imageAndMovement

            GroupBox {
                id: imageGroup
                title: Constants.eventImageTitle
                hint: Constants.eventImageHint
                EventImageBox {
                    member: "image"
                    title: imageGroup.title
                    hint: imageGroup.hint
                    labelVisible: false
                    mapId: root.mapId
                    onTypeChanged: {
                        priorityType.currentIndex = characterName ? 1 : 0;
                    }
                }
            }

            GroupBox {
                title: qsTr("Autonomous Movement")
                hint: qsTr("Settings for autonomous movement. The event moves automatically by this settings if not controlled by other events.")
                ControlsColumn {
                    Column {
                        spacing: 2
                        ObjComboBox {
                            id: moveTypeBox
                            title: qsTr("Type", "Movement Type")
                            hint: qsTr("Type of autonomous movement.<br>[Fixed] Do not move from the position in which it was placed.<br>[Random] Moves passable tiles around freely.<br>[Approach] Moves toward the current location of the player.<br>[Custom] Moves along the specified route.")
                            member: "moveType"
                            model: [
                                qsTr("Fixed"), qsTr("Random"), qsTr("Approach"), qsTr("Custom")
                            ]
                            horizontal: true
                            itemWidth: 130
                            minimumLabelWidth: 60
                            spacing: 2
                        }
                        Button {
                            x: 80
                            width: 100
                            text: qsTr("Route") + "..."
                            hint: qsTr("Opens the route setting window when the movement type is [Custom].")
                            enabled: moveTypeBox.currentIndex === 3
                            onClicked: routeDialog.open()
                        }
                    }
                    MovementSpeedBox {
                        member: "moveSpeed"
                        title: qsTr("Speed", "Movement Speed")
                        horizontal: true
                        minimumLabelWidth: 60
                        spacing: 2
                    }
                    MovementFrequencyBox {
                        member: "moveFrequency"
                        title: qsTr("Freq", "Movement Frequency")
                        horizontal: true
                        minimumLabelWidth: 60
                        spacing: 2
                    }
                }
            }
        }

        GroupBoxRow {
            GroupBox {
                title: qsTr("Options")
                hint: qsTr("Options for character animation, passage, etc.")
                width: 130
                height: priorityAndTrigger.height
                ControlsColumn {
                    spacing: 7
                    ObjCheckBox {
                        member: "walkAnime"
                        text: qsTr("Walking", "Walking Animation")
                        hint: qsTr("Turns on the animation when the character is moving.")
                    }
                    ObjCheckBox {
                        member: "stepAnime"
                        text: qsTr("Stepping", "Stepping Animation")
                        hint: qsTr("Turns on the animation when the character is not moving.")
                    }
                    ObjCheckBox {
                        member: "directionFix"
                        text: qsTr("Direction Fix")
                        hint: qsTr("Makes it impossible to change the direction of the character.")
                    }
                    ObjCheckBox {
                        member: "through"
                        text: qsTr("Through")
                        hint: qsTr("Makes it possible to move through impassable tiles and characters.")
                    }
                }
            }
            GroupBoxColumn {
                id: priorityAndTrigger
                GroupBox {
                    id: priorityTypeGroup
                    title: qsTr("Priority")
                    hint: qsTr("Display priority of the event. However, when the image is a tile and the priority is [Below characters], the tileset settings will be used.")
                    ObjComboBox {
                        id: priorityType
                        title: priorityTypeGroup.title
                        hint: priorityTypeGroup.hint
                        member: "priorityType"
                        model: [
                            qsTr("Below characters"), qsTr("Same as characters"), qsTr("Above characters")
                        ]
                        labelVisible: false
                        itemWidth: 170
                    }
                }
                GroupBox {
                    id: triggerGroup
                    title: qsTr("Trigger")
                    hint: qsTr("Condition to start the event.<br>[Action Button] Starts when the player presses the button.<br>[Player Touch] In addition to the above, starts when the player touches the event.<br>[Event Touch] In addition to the above, starts when the event touches the player.<br>[Autorun] Starts when the event appears.<br>[Parallel] Runs cyclically while the event is present.")
                    ObjComboBox {
                        title: triggerGroup.title
                        hint: triggerGroup.hint
                        member: "trigger"
                        model: [
                            qsTr("Action Button"), qsTr("Player Touch"), qsTr("Event Touch"), qsTr("Autorun"), qsTr("Parallel")
                        ]
                        labelVisible: false
                        itemWidth: 170
                    }
                }
            }
        }
    }

    GroupBox {
        title: qsTr("Contents")
        hint: qsTr("Event commands to be run for this event. Right-click to open the popup menu.")

        ControlsRow {
            EventCommandListBox {
                list: dataObject ? dataObject.list : []
                width: 838 // Increased by 200
                height: 722 // Increased by 200
            }
        }
    }

    Dialog_MovementRoute {
        id: routeDialog
        onInit: {
            var route = DataManager.getObjectValue(dataObject, "moveRoute", null);
            list = DataManager.getObjectValue(route, "list", [ { code: 0 } ]);
            repeat = DataManager.getObjectValue(route, "repeat", false);
            skippable = DataManager.getObjectValue(route, "skippable", false);
        }
        onOk: {
            var route = DataManager.getObjectValue(dataObject, "moveRoute", null);
            DataManager.setObjectValue(route, "list", list);
            DataManager.setObjectValue(route, "repeat", repeat);
            DataManager.setObjectValue(route, "skippable", skippable);
            DataManager.setObjectValue(route, "wait", false);
        }
    }
}
