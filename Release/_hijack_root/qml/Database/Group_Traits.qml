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

    property string member: "traits"

    title: qsTr("Traits")
    hint: qsTr("List of the traits to give this data item.")

    property alias itemWidth: listBox.width
    property alias itemHeight: listBox.height

    Dialog_Traits {
        id: dialog
        locator: root
        onOk: listBox.finishEdit({ code: code, dataId: dataId, value: value })
    }

    Row {
        SmartListBox {
            id: listBox
            member: root.member
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent
            width: 320 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") // [OneMaker MV] - Window Increased
            height: 369
            dragDrop: true

            ListBoxColumn {
                title: qsTr("Type")
                role: "type"
                width: 124 + OneMakerMVSettings.getWindowSetting("windowSizes", "groupTraitsListBoxWidth") // [OneMaker MV] - Window Increased
            }
            ListBoxColumn {
                title: qsTr("Content")
                role: "content"
                width: 178 + OneMakerMVSettings.getWindowSetting("windowSizes", "alternativeWidthIncrease") // [OneMaker MV] - Window Increased
            }

            function editItem(data) {
                if (data) {
                    dialog.code = data.code;
                    dialog.dataId = data.dataId;
                    dialog.value = data.value;
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
                var value = data.value;
                var sign = value >= 0 ? " + " : " - ";
                var percent = (Math.floor(Math.abs(value) * 1000) / 10) + "%";
                switch (data.code) {
                case Constants._TRAIT_ELEMENT_RATE:
                    item.type = qsTr("Element Rate");
                    item.content = DataManager.elementName(dataId) + " * " + percent;
                    break;
                case Constants._TRAIT_DEBUFF_RATE:
                    item.type = qsTr("Debuff Rate");
                    item.content = Constants.paramName(dataId) + " * " + percent;
                    break;
                case Constants._TRAIT_STATE_RATE:
                    item.type = qsTr("State Rate");
                    item.content = DataManager.stateNameOrId(dataId) + " * " + percent;
                    break;
                case Constants._TRAIT_STATE_RESIST:
                    item.type = qsTr("State Resist");
                    item.content = DataManager.stateNameOrId(dataId);
                    break;
                case Constants._TRAIT_PARAM:
                    item.type = qsTr("Parameter");
                    item.content = Constants.paramName(dataId) + " * " + percent;
                    break;
                case Constants._TRAIT_XPARAM:
                    item.type = qsTr("Ex-Parameter");
                    item.content = Constants.xparamName(dataId) + sign + percent;
                    break;
                case Constants._TRAIT_SPARAM:
                    item.type = qsTr("Sp-Parameter");
                    item.content = Constants.sparamName(dataId) + " * " + percent;
                    break;
                case Constants._TRAIT_ATK_ELEMENT:
                    item.type = qsTr("Attack Element");
                    item.content = DataManager.elementName(dataId);
                    break;
                case Constants._TRAIT_ATK_STATE:
                    item.type = qsTr("Attack State");
                    item.content = DataManager.stateNameOrId(dataId) + " + " + percent;
                    break;
                case Constants._TRAIT_ATK_SPEED:
                    item.type = qsTr("Attack Speed");
                    item.content = value.toString();
                    break;
                case Constants._TRAIT_ATK_TIMES:
                    item.type = qsTr("Attack Times +");
                    item.content = value.toString();
                    break;
                case Constants._TRAIT_STYPE_ADD:
                    item.type = qsTr("Add Skill Type");
                    item.content = DataManager.skillTypeName(dataId);
                    break;
                case Constants._TRAIT_STYPE_SEAL:
                    item.type = qsTr("Seal Skill Type");
                    item.content = DataManager.skillTypeName(dataId);
                    break;
                case Constants._TRAIT_SKILL_ADD:
                    item.type = qsTr("Add Skill");
                    item.content = DataManager.skillNameOrId(dataId);
                    break;
                case Constants._TRAIT_SKILL_SEAL:
                    item.type = qsTr("Seal Skill");
                    item.content = DataManager.skillNameOrId(dataId);
                    break;
                case Constants._TRAIT_EQUIP_WTYPE:
                    item.type = qsTr("Equip Weapon");
                    item.content = DataManager.weaponTypeName(dataId);
                    break;
                case Constants._TRAIT_EQUIP_ATYPE:
                    item.type = qsTr("Equip Armor");
                    item.content = DataManager.armorTypeName(dataId);
                    break;
                case Constants._TRAIT_EQUIP_LOCK:
                    item.type = qsTr("Lock Equip");
                    item.content = DataManager.equipTypeName(dataId);
                    break;
                case Constants._TRAIT_EQUIP_SEAL:
                    item.type = qsTr("Seal Equip");
                    item.content = DataManager.equipTypeName(dataId);
                    break;
                case Constants._TRAIT_SLOT_TYPE:
                    item.type = qsTr("Slot Type");
                    item.content = Constants.slotTypeName(dataId);
                    break;
                case Constants._TRAIT_ACTION_PLUS:
                    item.type = qsTr("Action Times +");
                    item.content = percent;
                    break;
                case Constants._TRAIT_SPECIAL_FLAG:
                    item.type = qsTr("Special Flag");
                    item.content = Constants.specialFlagName(dataId);
                    break;
                case Constants._TRAIT_COLLAPSE_TYPE:
                    item.type = qsTr("Collapse Effect");
                    item.content = Constants.collapseTypeName(dataId);
                    break;
                case Constants._TRAIT_PARTY_ABILITY:
                    item.type = qsTr("Party Ability");
                    item.content = Constants.partyAbilityName(dataId);
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
