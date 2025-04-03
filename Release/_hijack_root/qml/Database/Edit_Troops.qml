import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Dialogs"
import "../Layouts"
import "../Singletons"
import "../_OneMakerMV"

ControlsRow {
    id: root

    property int troopId: dataObject ? dataObject.id : 0

    signal nameModified()

    property var searchableFields: ([
        { name: "name", title: qsTr("Name"), hint: qsTr("Name of the troop.") },
    ])

    GroupBoxColumn {
        GroupBox {
            title: qsTr("General Settings")
            hint: qsTr("Basic troop settings.")

            Column {
                spacing: 10

                ControlsRow {
                    ObjTextField {
                        id: nameEdit
                        member: "name"
                        title: qsTr("Name")
                        hint: qsTr("Name of the troop.")
                        onModified: nameModified()
                    }
                    ControlsRow {
                        anchors.bottom: parent.bottom
                        Button {
                            text: qsTr("Auto-name")
                            hint: qsTr("Gives a name based on the names of the enemies within the troop.")
                            width: 140
                            onClicked: autoName()
                        }
                        Button {
                            text: qsTr("Change BG") + "..."
                            hint: qsTr("Changes the background images for editing and battle tests.")
                            width: 140
                            onClicked: bgSelector.open()
                        }
                        Button {
                            text: qsTr("Battle Test") + "..."
                            hint: qsTr("Runs a battle test with the current troop.")
                            width: 140
                            onClicked: battleTest()
                        }
                    }
                }

                ControlsRow {
                    TroopScreen {
                        id: screen
                        title: qsTr("Placement View")
                        hint: qsTr("Displays the enemies in the troop. Drag an enemy to move it. Right-click to open the popup menu.")
                        width: 280
                        height: 162 + OneMakerMVSettings.getWindowSetting("alternativeHeightIncrease") // [OneMaker MV] - Window Increased
                    }
                    ControlsColumn {
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text: "< " + title + " "
                            title: qsTr("Add")
                            hint: qsTr("Places the selected enemy into the troop.")
                            width: 120
                            enabled: screen.addEnabled && listBox.currentIndex >= 0
                            onClicked: screen.add(listBox.currentIndex + 1)
                        }
                        Button {
                            text: " " + title + " >"
                            title: qsTr("Remove")
                            hint: qsTr("Removes the selected enemy from the troop.")
                            width: 120
                            enabled: screen.removeEnabled
                            onClicked: screen.remove()
                        }
                        Button {
                            text: qsTr("Clear")
                            hint: qsTr("Removes all the enemies from the troop.")
                            width: 120
                            enabled: screen.clearEnabled
                            onClicked: screen.clear()
                        }
                        Button {
                            text: qsTr("Align")
                            hint: qsTr("Places all the enemies automatically.")
                            width: 120
                            enabled: screen.alignEnabled
                            onClicked: screen.align(true)
                        }
                    }
                    ListModel {
                        id: listModel
                    }
                    FindManagerListBox { // [OneMaker MV] - Change to obtain a find manager list box
                        id: listBox
                        title: qsTr("Enemy List")
                        hint: qsTr("Press the [Add] button on the left to add selected enemies to the troop.")
                        width: 220 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                        height: 162 + OneMakerMVSettings.getWindowSetting("alternativeHeightIncrease") // [OneMaker MV] - Window Increased

                        model: listModel
                        headerVisible: false

                        // [OneMaker MV] - Always show selection and disable all the broken menu items
                        showSelectionAlways: true

                        ListBoxColumn { role: "text" }

                        onDoubleClicked: screen.add(listBox.currentIndex + 1)
                        
                        // [OneMaker MV] - Add findManager
                        findManager: findMgr
                    }
                    Component.onCompleted: {
                        var dataSet = DataManager.getDataSet("enemies");
                        if (dataSet) {
                            for (var id = 1; id < dataSet.length; id++) {
                                var text = DataManager.makeIdText(id, 4) + " " + dataSet[id].name;
                                listModel.append({ value: id, text: text });
                            }
                        }
                    }
                }
            }
        }
        Group_BattleEvent {
            troopId: root.troopId
        }
    }

    Dialog_ImageSelector {
        id: bgSelector
        folder: DataManager.projectUrl + "img/" + "battlebacks1"
        folder2: DataManager.projectUrl + "img/" + "battlebacks2"
        imageScale: 0.36
        imageDual: true

        onInit: {
            imageName = DataManager.getSystemValue("battleback1Name", "");
            imageName2 = DataManager.getSystemValue("battleback2Name", "");
        }

        onOk: {
            DataManager.setSystemValue("battleback1Name", imageName);
            DataManager.setSystemValue("battleback2Name", imageName2);
            screen.updateBattlebackImages();
            helper.setModified();
        }
    }

    Dialog_BattleTest {
        id: battleTestDialog
        onOk: {
            var testBattlers = battleTestDialog.testBattlers;
            DataManager.setSystemValue("testBattlers", testBattlers);
            DataManager.setSystemValue("testTroopId", troopId);
            DataManager.saveTestData();
            gamePlayer.open();
        }
    }

    Dialog_GamePlayer {
        id: gamePlayer
        battleTest: true
    }

    DialogBoxHelper { id: helper }

    // [OneMaker MV] - Add FindManager Control
    FindManager {
            id: findMgr
            scopeTitle: qsTr("Enemy List")

            searchableFields: ([
                { name: "text", title: qsTr("Enemy Name"), hint: qsTr("Search for an Enemies Name.") },
            ])

            function getItemCount() {
                return listBox.rowCount;
            }

            function getItem(index) {
                return listBox.model.get(index);
            }

            function getCurrentIndex() {
                return listBox.currentIndex;
            }

            function setCurrentIndex(index) {
                listBox.currentIndex = index;
                listBox.positionViewAtIndex(listBox.currentIndex, ListView.Contain);
            }
        }

    Component.onDestruction: {
        DataManager.removeTestData();
    }

    function autoName() {
        var troopName = "";
        var members = DataManager.getObjectValue(dataObject, "members", "");
        var flags = [];
        for (var i = 0; i < members.length; i++) {
            if (!flags[i]) {
                var enemyId = members[i].enemyId;
                var count = 0;
                for (var j = 0; j < members.length; j++) {
                    if (members[j].enemyId === enemyId) {
                        flags[j] = true;
                        count++;
                    }
                }
                var enemyName = DataManager.enemyName(enemyId);
                if (troopName.length > 0) {
                    troopName += ", ";
                }
                troopName += enemyName;
                if (count > 1) {
                    troopName += "*" + count;
                }
            }
        }
        nameEdit.text = troopName;
    }

    function battleTest() {
        battleTestDialog.testBattlers = [];
        for (var i = 0; i < 4; i++) {
            var testBattlers = DataManager.getSystemValue("testBattlers", []);
            var battler = { actorId: 0, level: 1, equips: [] };
            if (testBattlers[i]) {
                battler.actorId = testBattlers[i].actorId;
                battler.level = testBattlers[i].level;
                battler.equips = testBattlers[i].equips.slice(0);
            }
            battleTestDialog.testBattlers[i] = battler;
        }
        battleTestDialog.open();
    }
}
