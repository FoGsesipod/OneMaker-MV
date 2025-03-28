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

    property string member: "actions"

    title: qsTr("Action Patterns")
    hint: qsTr("List of enemy actions in battle.")

    property alias itemWidth: listBox.width
    property alias itemHeight: listBox.height

    Dialog_Action {
        id: dialog
        locator: root
        onOk: listBox.finishEdit(
                  { skillId: skillId, rating: rating, conditionType: conditionType,
                      conditionParam1: conditionParam1, conditionParam2: conditionParam2 })
    }

    Row {
        SmartListBox {
            id: listBox
            member: root.member
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent
            width: 390
            height: 208 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease") // [OneMaker MV] - Window Increased
            dragDrop: true

            ListBoxColumn {
                title: qsTr("Skill")
                role: "skill"
                width: 160
            }
            ListBoxColumn {
                title: qsTr("Condition")
                role: "condition"
                width: 170
            }
            ListBoxColumn {
                title: qsTr("R", "Rating")
                role: "rating"
                width: 42
            }

            function editItem(data) {
                if (data) {
                    dialog.skillId = data.skillId;
                    dialog.conditionType = data.conditionType;
                    dialog.conditionParam1 = data.conditionParam1;
                    dialog.conditionParam2 = data.conditionParam2;
                    dialog.rating = data.rating;
                } else {
                    dialog.reset();
                }
                dialog.open();
            }

            function makeModelItem(data) {
                var item = {};
                if (data) {
                    item.skill = DataManager.skillName(data.skillId);
                    item.rating = data.rating.toString();
                    var param1 = data.conditionParam1;
                    var param2 = data.conditionParam2;
                    var percent1 = (Math.floor(Math.abs(param1) * 10000) / 100) + "%";
                    var percent2 = (Math.floor(Math.abs(param2) * 10000) / 100) + "%";
                    switch (data.conditionType) {
                    case 0:
                        item.condition = qsTr("Always");
                        break;
                    case 1:
                        item.condition = qsTr("Turn") + " ";
                        if (param1 !== 0) {
                            item.condition += param1;
                            if (param2 !== 0) {
                                item.condition += "+";
                            }
                        }
                        if (param2 !== 0) {
                            item.condition += param2 + "*X";
                        }
                        if (param1 === 0 && param2 === 0) {
                            item.condition +="0";
                        }
                        break;
                    case 2:
                        item.condition = qsTr("HP") + " " + percent1 + " ~ " + percent2;
                        break;
                    case 3:
                        item.condition = qsTr("MP") + " " + percent1 + " ~ " + percent2;
                        break;
                    case 4:
                        item.condition = qsTr("State") + " " + DataManager.stateName(param1);
                        break;
                    case 5:
                        item.condition = qsTr("Party Level") + " >= " + param1;
                        break;
                    case 6:
                        item.condition = "{" + DataManager.switchNameOrId(param1) + "}";
                        break;
                    default:
                        break;
                    }
                } else {
                    item.skill = "";
                    item.condition = "";
                    item.rating = "";
                }
                return item;
            }
        }
    }
}
