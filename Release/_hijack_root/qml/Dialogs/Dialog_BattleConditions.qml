import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Conditions")

    property var dataObject: null;
    property int troopId: 0

    property string groupTitle: ""
    property string groupHint: ""

    DialogBox {
        applyVisible: false

        GroupBoxColumn {
            GroupBox {
                id: conditionsGroup
                title: groupTitle
                hint: groupHint

                property int checkBoxWidth: 100
                property int itemHeight: 28

                ControlsColumn {
                    ExclusiveGroup { id: group }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox1
                            member: "turnEnding"
                            text: qsTr("Turn End")
                            hint: qsTr("Starts when all of the actions of enemies and actors have finished.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox2
                            member: "turnValid"
                            text: qsTr("Turn")
                            hint: qsTr("Starts when the specified turn has been surpassed. Specifies the turn count with A + B * X. If A = 1 and B = 3, the condition will be met at turn 1, 4, 7, and so on. Turn 0 means that the event starts before command entry.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        ObjSpinBox {
                            member: "turnA"
                            title: checkBox2.title
                            hint: checkBox2.hint
                            enabled: checkBox2.checked
                            itemWidth: 80
                            minimumValue: 0
                            maximumValue: 9999
                            labelVisible: false
                        }
                        Label {
                            title: checkBox2.title
                            hint: checkBox2.hint
                            enabled: checkBox2.checked
                            anchors.verticalCenter: parent.verticalCenter
                            text: "+"
                        }
                        ObjSpinBox {
                            member: "turnB"
                            title: checkBox2.title
                            hint: checkBox2.hint
                            enabled: checkBox2.checked
                            itemWidth: 80
                            minimumValue: 0
                            maximumValue: 9999
                            labelVisible: false
                        }
                        Label {
                            title: checkBox2.title
                            hint: checkBox2.hint
                            enabled: checkBox2.checked
                            anchors.verticalCenter: parent.verticalCenter
                            text: "* X "
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox3
                            member: "enemyValid"
                            text: qsTr("Enemy HP")
                            hint: qsTr("Starts when an enemy's HP is less than or equal to the specified percentage.<br>If you want to start the event just before the enemy dies, add [Immortal] state temporarily on the battle start.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        ObjTroopMemberBox {
                            member: "enemyIndex"
                            title: checkBox3.title
                            hint: checkBox3.hint
                            enabled: checkBox3.checked
                            troopId: root.troopId
                            labelVisible: false
                        }
                        ObjSpinBox {
                            member: "enemyHp"
                            title: checkBox3.title
                            hint: checkBox3.hint
                            enabled: checkBox3.checked
                            suffix: " %"
                            itemWidth: 80
                            minimumValue: 0
                            maximumValue: 100
                            labelVisible: false
                        }
                        Label {
                            title: checkBox3.title
                            hint: checkBox3.hint
                            enabled: checkBox3.checked
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("or below")
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox4
                            member: "actorValid"
                            text: qsTr("Actor HP")
                            hint: qsTr("Starts when an actor's HP is less than or equal to the specified percentage.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        GameObjectBox {
                            member: "actorId"
                            title: checkBox4.title
                            hint: checkBox4.hint
                            enabled: checkBox4.checked
                            dataSetName: "actors"
                            labelVisible: false
                        }
                        ObjSpinBox {
                            member: "actorHp"
                            title: checkBox4.title
                            hint: checkBox4.hint
                            enabled: checkBox4.checked
                            suffix: " %"
                            itemWidth: 80
                            minimumValue: 0
                            maximumValue: 100
                            labelVisible: false
                        }
                        Label {
                            title: checkBox4.title
                            hint: checkBox4.hint
                            enabled: checkBox4.checked
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("or below")
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox5
                            member: "switchValid"
                            text: qsTr("Switch")
                            hint: qsTr("Starts when the specified switch is ON.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        GameSwitchBox {
                            member: "switchId"
                            id: switchBox
                            title: checkBox5.title
                            hint: checkBox5.hint
                            enabled: checkBox5.checked
                            labelVisible: false
                        }
                    }
                    
                    // [OneMaker MV] - Additional conditions for troops
                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox6
                            member: "variableValid"
                            text: qsTr("Variable")
                            hint: qsTr("Starts when the specified variable is greater then or equal to the value.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        GameVariableBox {
                            id: variableIdBox
                            member: "variableId"
                            title: checkBox6.title
                            hint: checkBox6.hint
                            enabled: checkBox6.checked
                            labelVisible: false
                        }
                        ObjComboBox {
                            id: variableOperatorBox
                            member: "variableOperator"
                            title: qsTr("Operator")
                            hint: qsTr("Variable operator to use.")
                            itemWidth: 75
                            model: Constants.eventConditionOperatorArray
                            enabled: checkBox6.checked
                            labelVisible: false
                        }
                        ObjSpinBox {
                            id: selfVariableValueBox
                            member: "variableValue"
                            title: checkBox6.title
                            hint: checkBox6.hint
                            width: 100
                            minimumValue: -99999999
                            maximumValue: 99999999
                            enabled: checkBox6.checked
                            labelVisible: false
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox7
                            member: "stateValid"
                            text: qsTr("State")
                            hint: qsTr("Starts if an Actor/Enemy is affected by a state")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        ObjComboBox {
                            id: stateCharacterBox
                            member: "stateCharacter"
                            title: checkBox7.title
                            hint: checkBox7.hint
                            itemWidth: 75
                            model: ["Actor", "Enemy"]
                            enabled: checkBox7.checked
                            labelVisible: false
                        }
                        GameObjectBox {
                            id: stateActorBox
                            member: "stateActorId"
                            title: checkBox7.title
                            hint: checkBox7.hint
                            itemWidth: 125
                            enabled: checkBox7.checked
                            visible: !stateCharacterBox.currentIndex
                            dataSetName: "actors"
                            labelVisible: false
                        }
                        ObjTroopMemberBox {
                            id: stateEnemyBox
                            member: "stateEnemyIndex"
                            title: checkBox7.title
                            hint: checkBox7.hint
                            itemWidth: 125
                            enabled: checkBox7.checked
                            visible: stateCharacterBox.currentIndex
                            troopId: root.troopId
                            labelVisible: false
                        }
                        GameObjectBox {
                            id: stateValueBox
                            member: "stateValue"
                            title: checkBox7.title
                            hint: checkBox7.hint
                            itemWidth: 150
                            dataSetName: "states"
                            enabled: checkBox7.checked
                            labelVisible: false
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox8
                            member: "partyValid"
                            text: qsTr("Party Has")
                            hint: qsTr("Starts if the party has a item/armor/weapon.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        ObjComboBox {
                            id: itemTypeBox
                            member: "partyType"
                            title: checkBox8.title
                            hint: checkBox8.hint
                            itemWidth: 100
                            model: ["Item", "Weapon", "Armor"]
                            enabled: checkBox8.checked
                            labelVisible: false
                        }
                        GameObjectBox {
                            id: itemValueBox
                            member: "partyId"
                            title: checkBox8.title
                            hint: checkBox8.hint
                            itemWidth: 200
                            dataSetName: ["items", "weapons", "armors"][itemTypeBox.currentIndex]
                            enabled: checkBox8.checked
                            labelVisible: false
                        }
                    }

                    ControlsRow {
                        ObjCheckBox {
                            id: checkBox9
                            member: "scriptValid"
                            text: qsTr("Script")
                            hint: qsTr("Syntax: {run = boolean}\n\nStarts if run equals true.")
                            width: conditionsGroup.checkBoxWidth
                            height: conditionsGroup.itemHeight
                        }
                        ObjTextField {
                            id: scriptField
                            member: "script"
                            title: checkBox9.title
                            hint: checkBox9.hint
                            itemWidth: 350
                            enabled: checkBox9.checked
                            labelVisible: false
                        }
                    }
                }
            }
        }
    }
}
