import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Event"
import "../Singletons"

ControlsRow {
    id: root

    signal nameModified()

    property var searchableFields: ([
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the common event.") },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic common event settings.")

            ControlsRow {
                ObjTextField {
                    member: "name"
                    title: qsTr("Name")
                    hint: qsTr("Name of the common event.")
                    onModified: nameModified()
                }
                ObjComboBox {
                    id: triggerBox
                    member: "trigger"
                    title: qsTr("Trigger")
                    hint: qsTr("Conditions to start the common event. Valid only on the map screen.<br>[None] Starts only when explicitly called up.<br>[Autorun] Starts when the specified switch is ON.<br>[Parallel] Runs cyclically while the specified switch is ON.")
                    model: [qsTr("None"), qsTr("Autorun"), qsTr("Parallel")]
                }
                GameSwitchBox {
                    member: "switchId"
                    title: qsTr("Switch")
                    hint: qsTr("When the trigger is [Autorun] or [Parallel], the contents will be run when the switch set here is ON.")
                    enabled: triggerBox.currentIndex > 0
                }
            }
        }

        GroupBox {
            title: qsTr("Contents")
            hint: qsTr("Event commands to be run for this event. Right-click to open the popup menu.")

            ControlsRow {
                EventCommandListBox {
                    list: dataObject ? dataObject.list : []
                    width: 740 + WindowSizes.defaultWidthIncrease // [OneMaker MV] - Window Increased
                    height: 498 + WindowSizes.defaultHeightIncrease // [OneMaker MV] - Window Increased
                }
            }
        }
    }
}
