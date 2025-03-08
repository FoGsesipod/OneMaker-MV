import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

GroupBox {
    id: root
    title: qsTr("Conditions")
    hint: qsTr("Specifies conditions for which the event appears on the map. If no conditions are specified, the event appears unconditionally. Higher numbered page has a higher priority.")

    property int checkBoxWidth: 110
    property int itemHeight: 28

    ControlsColumn {
        ExclusiveGroup { id: group }

        ControlsRow {
            ObjCheckBox {
                id: checkBox1
                member: "conditions.switch1Valid"
                text: qsTr("Switch")
                hint: qsTr("Appears when the specified switch is ON.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            GameSwitchBox {
                member: "conditions.switch1Id"
                title: checkBox1.title
                hint: checkBox1.hint
                enabled: checkBox1.checked
                labelVisible: false
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox2
                member: "conditions.switch2Valid"
                text: qsTr("Switch")
                hint: qsTr("Appears when the specified switch is ON.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            GameSwitchBox {
                member: "conditions.switch2Id"
                title: checkBox2.title
                hint: checkBox2.hint
                enabled: checkBox2.checked
                labelVisible: false
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox3
                member: "conditions.variableValid"
                text: qsTr("Variable")
                hint: qsTr("Appears when the specified variable is greater than or equal to the given value.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            ControlsColumn {
                enabled: checkBox3.checked
                GameVariableBox {
                    member: "conditions.variableId"
                    title: checkBox3.title
                    hint: checkBox3.hint
                    labelVisible: false
                }
                ControlsRow {
                    ObjComboBox {
                        member: "conditions.variableOperator"
                        title: qsTr("Operator")
                        hint: qsTr("Variable Operator to use")
                        itemWidth: 75
                        model: Constants.variableConditionOperatorArray
                        labelVisible: false
                    }
                    ObjSpinBox {
                        member: "conditions.variableValue"
                        title: checkBox3.title
                        hint: checkBox3.hint
                        labelVisible: false
                        itemWidth: 100
                        minimumValue: -99999999
                        maximumValue: 99999999
                    }
                }
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox4
                member: "conditions.selfSwitchValid"
                text: qsTr("Self Switch")
                hint: qsTr("Appears when the specified self switch is ON.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            SelfSwitchBox {
                member: "conditions.selfSwitchCh"
                title: checkBox4.title
                hint: checkBox4.hint
                enabled: checkBox4.checked
                labelVisible: false
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox5
                member: "conditions.itemValid"
                text: qsTr("Item")
                hint: qsTr("Appears when the party has the specified item.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            GameObjectBox {
                member: "conditions.itemId"
                title: checkBox5.title
                hint: checkBox5.hint
                enabled: checkBox5.checked
                dataSetName: "items"
                labelVisible: false
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox6
                member: "conditions.actorValid"
                text: qsTr("Actor")
                hint: qsTr("Appears when the specified actor is in the party.")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            GameObjectBox {
                member: "conditions.actorId"
                title: checkBox6.title
                hint: checkBox6.hint
                enabled: checkBox6.checked
                dataSetName: "actors"
                labelVisible: false
            }
        }

        ControlsRow {
            ObjCheckBox {
                id: checkBox7
                member: "conditions.scriptValid"
                text: qsTr("Script")
                hint: qsTr("")
                width: root.checkBoxWidth
                height: root.itemHeight
            }
            ObjTextField {
                member: "conditions.script"
                title: qsTr("Script Command")
                hint: qsTr("Syntax: {run = Boolean}\n\nThis code will only run on $gameMap.refresh() updates.\nThis is usually called for Variable and Switch changes, obtaining items, when an event ends, and some other calls.")
                enabled: checkBox7.checked
                labelVisible: false
            }
        }
    }
}
