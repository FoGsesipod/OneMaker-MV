import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Singletons"
import "../_OneMakerMV"

ControlsRow {
    id: root

    signal nameModified()

    property var searchableFields: ([
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the armor.") },
        { name: "description", title: qsTr("Description"), hint: qsTr("Comment displayed when the armor is selected in the game.") },
        { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic armor settings.")

            ControlsColumn {
                ControlsRow {
                    ObjTextField {
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the armor.")
                        onModified: nameModified()
                    }
                    ObjIconImageBox {
                        member: "iconIndex"
                        title: qsTr("Icon")
                        hint: qsTr("Icon appearing to the left of the armor name in the game.")
                    }
                }
                ObjTextArea {
                    member: "description"
                    title: qsTr("Description")
                    hint: qsTr("Comment displayed when the armor is selected in the game.")
                }
                ControlsRow {
                    ObjSelectBox {
                        member: "atypeId"
                        title: qsTr("Armor Type")
                        hint: qsTr("Type of the armor. Setting [Equip Armor] in trait lists enables to equip with them.")
                        dataSetName: "system"
                        systemDataName: "armorTypes"
                        includeZero: true
                    }
                    ObjSpinBox {
                        member: "price"
                        title: qsTr("Price")
                        hint: qsTr("Armor price. The player can sell the armor for half of this price when the price is greater than 0.")
                        minimumValue: 0
                        maximumValue: 999999
                    }
                }
                ControlsRow {
                    ObjSelectBox {
                        member: "etypeId"
                        title: qsTr("Equipment Type")
                        hint: qsTr("Where the armor is equipped. Actors can equip different kinds of armor at the same time.")
                        dataSetName: "system"
                        systemDataName: "equipTypes"
                        excludeOne: true
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
            itemWidth: 320 + OneMakerMVSettings.getWindowSetting("groupNoteDatabaseWidth") // [OneMaker MV] - Group Note Width and Position Changed
            x: OneMakerMVSettings.getWindowSetting("groupNoteDatabaseX") // [OneMaker MV] - Group Note Width and Position Changed
        }
    }
}
