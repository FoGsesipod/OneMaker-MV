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

    property string member: "learnings"

    title: qsTr("Skills to Learn")
    hint: qsTr("Skills mastered at level-up for actors in this class.")

    property alias itemWidth: listBox.width
    property alias itemHeight: listBox.height

    Dialog_SkillsToLearn {
        id: dialog
        locator: root

        function setDataObject(data) {
            if (data) {
                dataObject = DataManager.clone(data);
            } else {
                dataObject = { level: 1, skillId: 1, note: "" };
            }
        }

        onOk: {
            listBox.finishEdit(dataObject);
        }
    }

    Row {
        SmartListBox {
            id: listBox
            member: root.member
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent
            width: 390
            height: 318 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease") // [OneMaker MV] - Window Increased
            dragDrop: true

            ListBoxColumn {
                title: qsTr("Level")
                role: "level"
                width: 70
            }
            ListBoxColumn {
                title: qsTr("Skill")
                role: "skill"
                width: 160
            }
            ListBoxColumn {
                title: qsTr("Note")
                role: "note"
                width: 142
            }

            function editItem(data) {
                dialog.setDataObject(data);
                dialog.open();
            }

            function makeModelItem(data) {
                var item = {};
                if (data) {
                    item.level = "Lv " + (" " + (data.level || "?")).slice(-2);
                    item.skill = DataManager.skillName(data.skillId);
                    item.note = data.note;
                } else {
                    item.level = "";
                    item.skill = "";
                    item.note = "";
                }
                return item;
            }
        }
    }
}
