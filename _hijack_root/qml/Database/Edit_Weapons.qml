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
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the weapon.") },
        { name: "description", title: qsTr("Description"), hint: qsTr("Comment displayed when the weapon is selected in the game.") },
        { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic weapon settings.")

            ControlsColumn {
                ControlsRow {
                    ObjTextField {
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the weapon.")
                        onModified: nameModified()
                    }
                    ObjIconImageBox {
                        member: "iconIndex"
                        title: qsTr("Icon")
                        hint: qsTr("Icon appearing to the left of the weapon name in the game.")
                    }
                }
                ObjTextArea {
                    member: "description"
                    title: qsTr("Description")
                    hint: qsTr("Comment displayed when the weapon is selected in the game.")
                }
                ControlsRow {
                    ObjSelectBox {
                        member: "wtypeId"
                        title: qsTr("Weapon Type")
                        hint: qsTr("Type of the weapon. Setting [Equip Weapon] in trait lists enables to equip with them.")
                        dataSetName: "system"
                        systemDataName: "weaponTypes"
                        includeZero: true
                    }
                    ObjSpinBox {
                        member: "price"
                        title: qsTr("Price")
                        hint: qsTr("Weapon price. The player can sell the weapon for half of this price when the price is greater than 0.")
                        minimumValue: 0
                        maximumValue: 999999
                    }
                }
                ControlsRow {
                    GameObjectBox {
                        member: "animationId"
                        title: qsTr("Animation")
                        hint: qsTr("Animation displayed for the target when using this weapon in battle.")
                        dataSetName: "animations"
                        includeZero: true
                    }
                }
            }
        }
        Group_ParameterChanges {
        }
    }
    GroupBoxColumn {
        Group_Traits {
        }
        Group_Note {
            itemWidth: 940  // Adjusted width and position
            x: -420         // Adjusted width and position
        }
    }
}
