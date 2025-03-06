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

    property string memberForParams: "params"

    property var searchableFields: ([
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the enemy.") },
        { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic enemy settings.")

            ControlsRow {
                ControlsColumn {
                    ObjTextField {
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the enemy.")
                        onModified: nameModified()
                    }
                    ObjImageBox {
                        memberForName: "battlerName"
                        memberForHue: "battlerHue"
                        title: qsTr("Image")
                        hint: qsTr("Image of the enemy to be displayed in battle.")
                        subFolder: DataManager.enemiesFolder
                        imageScale: 1/3
                        selectorImageScale: 3/4
                        itemWidth: 190
                        itemHeight: 127
                    }
                }
                ControlsColumn {
                    ControlsRow {
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.mhpIndex
                            title: Constants.mhpName
                            hint: Constants.mhpHint
                            minimumValue: 1
                            maximumValue: 999999
                        }
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.mmpIndex
                            title: Constants.mmpName
                            hint: Constants.mmpHint
                            minimumValue: 0
                            maximumValue: 9999
                        }
                    }
                    ControlsRow {
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.atkIndex
                            title: Constants.atkName
                            hint: Constants.atkHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.defIndex
                            title: Constants.defName
                            hint: Constants.defHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                    }
                    ControlsRow {
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.matIndex
                            title: Constants.matName
                            hint: Constants.matHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.mdfIndex
                            title: Constants.mdfName
                            hint: Constants.mdfHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                    }
                    ControlsRow {
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.agiIndex
                            title: Constants.agiName
                            hint: Constants.agiHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                        ObjSpinBox {
                            member: root.memberForParams + "." + Constants.lukIndex
                            title: Constants.lukName
                            hint: Constants.lukHint
                            minimumValue: 1
                            maximumValue: 999
                        }
                    }
                }
            }
        }
        GroupBoxRow {
            GroupBox {
                id: rewardsBox
                title: qsTr("Rewards")
                hint: qsTr("EXP and Gold earned for defeating this enemy.")

                ControlsColumn {
                    ObjSpinBox {
                        member: "exp"
                        title: qsTr("EXP")
                        hint: qsTr("EXP earned by the party by winning a battle.")
                        minimumValue: 0
                        maximumValue: 9999999
                    }
                    ObjSpinBox {
                        member: "gold"
                        title: qsTr("Gold")
                        hint: qsTr("Gold earned by the party by winning a battle.")
                        minimumValue: 0
                        maximumValue: 9999999
                    }
                }
            }
            GroupBox {
                id: dropItemsGroup
                title: qsTr("Drop Items")
                hint: qsTr("Items and equipment earned by the party by winning a battle.")
                height: rewardsBox.height

                ControlsColumn {
                    spacing: 8
                    EnemyDropItemBox {
                        member: "dropItems.0"
                        title: dropItemsGroup.title
                        hint: dropItemsGroup.hint
                        labelVisible: false
                        itemWidth: 270
                    }
                    EnemyDropItemBox {
                        member: "dropItems.1"
                        title: dropItemsGroup.title
                        hint: dropItemsGroup.hint
                        labelVisible: false
                        itemWidth: 270
                    }
                    EnemyDropItemBox {
                        member: "dropItems.2"
                        title: dropItemsGroup.title
                        hint: dropItemsGroup.hint
                        labelVisible: false
                        itemWidth: 270
                    }
                }
            }
        }
        //Group_ActionPatterns {    // Removed because its unused for OMORI
        //}                         // Removed because its unused for OMORI
    }
    GroupBoxColumn {
        Group_Traits {
        }
        Group_Note {
            itemWidth: Constants.groupNoteDatabaseWidth // Group Note Width and Position Changed
            x: Constants.groupNoteDatabaseX // Group Note Width and Position Changed
        }
    }
}
