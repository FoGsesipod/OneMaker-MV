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
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the item.") },
        { name: "description", title: qsTr("Description"), hint: qsTr("Comment displayed when the item is selected in the game.") },
        { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic item settings.")

            ControlsColumn {
                ControlsRow {
                    ObjTextField {
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the item.")
                        onModified: nameModified()
                    }
                    ObjIconImageBox {
                        member: "iconIndex"
                        title: qsTr("Icon")
                        hint: qsTr("Icon appearing to the left of the item name in the game.")
                    }
                }
                ObjTextArea {
                    member: "description"
                    title: qsTr("Description")
                    hint: qsTr("Comment displayed when the item is selected in the game.")
                }
                ControlsRow {
                    ObjComboBox {
                        member: "itypeId"
                        title: qsTr("Item Type")
                        hint: qsTr("Type of the item. Key items are typically related to story progression.")
                        model: Constants.itemTypeArray
                        indexOffset: 1
                    }
                    ObjSpinBox {
                        member: "price"
                        title: qsTr("Price")
                        hint: qsTr("Price of the item. The player can sell the item for half of this price when the price is greater than 0.")
                        minimumValue: 0
                        maximumValue: 999999
                    }
                    ObjYesNoBox {
                        member: "consumable"
                        title: qsTr("Consumable")
                        hint: qsTr("Whether or not the item disappears after use.")
                        model: [qsTr("Yes", "consumable"), qsTr("No", "consumable")]
                    }
                }
                ControlsRow {
                    ObjComboBox {
                        member: "scope"
                        title: qsTr("Scope")
                        hint: qsTr("Scope of the effect.")
                        model: Constants.scopeArray
                    }
                    ObjComboBox {
                        member: "occasion"
                        title: qsTr("Occasion")
                        hint: qsTr("Screen(s) on which the item can be used.")
                        model: Constants.occasionArray
                    }
                }
            }
        }
        Group_Invocation {
        }
    }
    GroupBoxColumn {
        Group_Damage {
        }
        Group_Effects {
        }
        Group_Note {
            itemWidth: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseWidth") // [OneMaker MV] - Group Note Width and Position Changed
            x: OneMakerMVSettings.getSetting("windowSizes", "groupNoteDatabaseX") // [OneMaker MV] - Group Note Width and Position Changed
        }
    }
}
