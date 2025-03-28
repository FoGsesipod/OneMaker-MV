import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"

GroupBox {
    id: root

    title: qsTr("Damage")
    hint: qsTr("Amount of damage or recovery applied to the target.")

    property bool damageTypeValid: damageType.currentIndex > 0

    ControlsColumn {
        ControlsRow {
            ObjComboBox {
                id: damageType
                member: "damage.type"
                title: qsTr("Type")
                hint: qsTr("Type of damage.")
                model: [ qsTr("None"), qsTr("HP Damage"), qsTr("MP Damage"), qsTr("HP Recover"), qsTr("MP Recover"), qsTr("HP Drain"), qsTr("MP Drain") ]
                itemWidth: 155 + OneMakerMVSettings.getWindowSetting("windowSizes", "alternativeWidthIncrease") // [OneMaker MV] - Window Increased
            }
            ObjSelectBox {
                member: "damage.elementId"
                title: qsTr("Element")
                hint: qsTr("Element of the damage. Final damage varies depending on the target's resistance to the element in question.")
                itemWidth: 155 + OneMakerMVSettings.getWindowSetting("windowSizes", "alternativeWidthIncrease") // [OneMaker MV] - Window Increased
                dataSetName: "system"
                systemDataName: "elements"
                includeZero: true
                minusOneText: qsTr("Normal Attack")
                enabled: damageTypeValid
            }
        }
        ControlsRow {
            ObjTextField {
                member: "damage.formula"
                title: qsTr("Formula")
                hint: qsTr("Formula for calculating basic damage. The user is expressed by a and the target by b, and then either one is followed by a dot to enable the referencing of the statuses shown hereafter. For example, \"a.atk\" stands for user's attack power.")
                hintComponent: paramHintTable
                itemWidth: 320 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") // [OneMaker MV] - Window Increased
                enabled: damageTypeValid

                contextMenu: TextEditPopupMenu {
                    MenuSeparator { }
                    MenuItem_PluginHelpEverywhere { }
                }
            }
        }
        ControlsRow {
            ObjSpinBox {
                member: "damage.variance"
                title: qsTr("Variance")
                hint: qsTr("Degree of variability. The value of the final damage will vary by this percentage value.")
                suffix: " %"
                minimumValue: 0
                maximumValue: 100
                enabled: damageTypeValid
            }
            ObjYesNoBox {
                member: "damage.critical"
                title: qsTr("Critical Hits")
                hint: qsTr("Whether to enable critical hits. When enabled, critical hits will be determined based on the user's critical rate and the target's critical evasion rate.")
                model: [qsTr("Yes", "critical"), qsTr("No", "critical")]
                enabled: damageTypeValid
            }
        }
    }

    Component {
        id: paramHintTable
        Column {
            property var texts: [
                "atk", Constants.atkName,
                "def", Constants.defName,
                "mat", Constants.matName,
                "mdf", Constants.mdfName,
                "agi", Constants.agiName,
                "luk", Constants.lukName,
                "mhp", Constants.mhpName,
                "mmp", Constants.mmpName,
                "hp", Constants.hpName,
                "mp", Constants.mpName,
                "tp", Constants.tpName,
                "level", Constants.levelName
            ]
            Repeater {
                model: 6
                Row {
                    PairedToolTipTexts {
                        text1: texts[index * 4 + 0]
                        text2: texts[index * 4 + 1]
                    }
                    PairedToolTipTexts {
                        text1: texts[index * 4 + 2]
                        text2: texts[index * 4 + 3]
                    }
                }
            }
        }
    }
}
