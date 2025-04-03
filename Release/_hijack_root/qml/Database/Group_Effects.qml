import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"
import "../_OneMakerMV"

GroupBox {
    id: root

    property string member: "effects"

    title: qsTr("Effects")
    hint: qsTr("List of the various effects other than damage.")

    property alias itemWidth: listBox.width
    property alias itemHeight: listBox.height

    Dialog_Effects {
        id: dialog
        locator: root
        onOk: listBox.finishEdit({ code: code, dataId: dataId, value1: value1, value2: value2 })
    }

    Row {
        SmartListBox {
            id: listBox
            member: root.member
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent
            width: 320 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
            height: 179
            dragDrop: true

            ListBoxColumn {
                title: qsTr("Type")
                role: "type"
                width: 124 + OneMakerMVSettings.getWindowSetting("groupEffectsListBoxWidth") // [OneMaker MV] - Window Increased
            }
            ListBoxColumn {
                title: qsTr("Content")
                role: "content"
                width: 178 + OneMakerMVSettings.getWindowSetting("alternativeWidthIncrease") // [OneMaker MV] - Window Increased
            }

            function editItem(data) {
                if (data) {
                    dialog.code = data.code;
                    dialog.dataId = data.dataId;
                    dialog.value1 = data.value1;
                    dialog.value2 = data.value2;
                } else {
                    dialog.reset();
                }
                dialog.open();
            }

            function makeModelItem(data) {
                var item = {};
                item.type = "";
                item.content = "";
                if (!data) {
                    return item;
                }
                var dataId = data.dataId;
                var value1 = data.value1;
                var value2 = data.value2;
                var percent1 = (Math.floor(value1 * 1000) / 10) + "%";
                var sign1 = value1 >= 0 ? " + " : " - ";
                var sign2 = value2 >= 0 ? " + " : " - ";
                switch (data.code) {
                case Constants._EFFECT_RECOVER_HP:
                    item.type = qsTr("Recover HP");
                    if (value1 === 0) {
                        item.content = value2.toString();
                    } else {
                        item.content = percent1;
                        if (value2 !== 0) {
                            item.content += sign2 + Math.abs(value2);
                        }
                    }
                    break;
                case Constants._EFFECT_RECOVER_MP:
                    item.type = qsTr("Recover MP");
                    if (value1 === 0) {
                        item.content = value2.toString();
                    } else {
                        item.content = percent1;
                        if (value2 !== 0) {
                            item.content += sign2 + Math.abs(value2);
                        }
                    }
                    break;
                case Constants._EFFECT_GAIN_TP:
                    item.type = qsTr("Gain TP");
                    item.content = value1.toString();
                    break;
                case Constants._EFFECT_ADD_STATE:
                    item.type = qsTr("Add State");
                    if (dataId === 0) {
                        item.content = qsTr("Normal Attack") + " " + percent1;
                    } else {
                        item.content = DataManager.stateNameOrId(dataId) + " " + percent1;
                    }
                    break;
                case Constants._EFFECT_REMOVE_STATE:
                    item.type = qsTr("Remove State");
                    item.content = DataManager.stateNameOrId(dataId) + " " + percent1;
                    break;
                case Constants._EFFECT_ADD_BUFF:
                    item.type = qsTr("Add Buff");
                    item.content = Constants.paramName(dataId) + " " + value1 + " " + qsTr("turns");
                    break;
                case Constants._EFFECT_ADD_DEBUFF:
                    item.type = qsTr("Add Debuff");
                    item.content = Constants.paramName(dataId) + " " + value1 + " " + qsTr("turns");
                    break;
                case Constants._EFFECT_REMOVE_BUFF:
                    item.type = qsTr("Remove Buff");
                    item.content = Constants.paramName(dataId);
                    break;
                case Constants._EFFECT_REMOVE_DEBUFF:
                    item.type = qsTr("Remove Debuff");
                    item.content = Constants.paramName(dataId);
                    break;
                case Constants._EFFECT_SPECIAL:
                    item.type = qsTr("Special Effect");
                    item.content = Constants.specialEffectName(dataId);
                    break;
                case Constants._EFFECT_GROW:
                    item.type = qsTr("Grow");
                    item.content = Constants.paramName(dataId) + sign1 + value1;
                    break;
                case Constants._EFFECT_LEARN_SKILL:
                    item.type = qsTr("Learn Skill");
                    item.content = DataManager.skillNameOrId(dataId);
                    break;
                case Constants._EFFECT_COMMON_EVENT:
                    item.type = qsTr("Common Event");
                    item.content = DataManager.commonEventNameOrId(dataId);
                    break;
                default:
                    item.type = qsTr("Undefined");
                    break;
                }
                return item;
            }
        }
    }
}
