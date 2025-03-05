import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../Controls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Database")

    autoCloseOnCancel: false

    property int currentTabIndex: 0

    DialogBox {
        id: dialogBox
        Row {
            HeavyProcessTimer {
                id: heavy
            }

            SideTabBar {
                id: sideTabBar
                tabView: databaseTabView
                currentIndex: 0
                onCurrentIndexChanged: {
                    heavy.run(function() {
                        databaseTabView.currentIndex = currentIndex;
                    });
                }
            }

            TabView {
                id: databaseTabView
                width: 1228 // Increased by 200
                height: 858 // Increased by 200
                tabsVisible: false

                Tab_DBStandard {
                    title: qsTr("Actors")
                    hint: qsTr("Data for player-controlled party members.")
                    templateName: "Actor"
                    dataSetName: "actors"
                    editorSource: "Edit_Actors.qml"
                }
                Tab_DBStandard {
                    title: qsTr("Classes")
                    hint: qsTr("Data that determines roles of actors within the party.")
                    templateName: "Class"
                    dataSetName: "classes"
                    editorSource: "Edit_Classes.qml"
                }
                Tab_DBStandard {
                    title: qsTr("Skills")
                    hint: qsTr("Data for actions that produce special effects by consuming MP or TP.")
                    templateName: "Skill"
                    dataSetName: "skills"
                    editorSource: "Edit_Skills.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("Items")
                    hint: qsTr("Data for non-equipment items, such as recovery and event items.")
                    templateName: "Item"
                    dataSetName: "items"
                    editorSource: "Edit_Items.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("Weapons")
                    hint: qsTr("Data for weapon items that increase attack power mainly.")
                    templateName: "Weapon"
                    dataSetName: "weapons"
                    editorSource: "Edit_Weapons.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("Armors")
                    hint: qsTr("Data for armor items that increase defense power mainly.")
                    templateName: "Armor"
                    dataSetName: "armors"
                    editorSource: "Edit_Armors.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("Enemies")
                    hint: qsTr("Data for enemies fought in battles.")
                    templateName: "Enemy"
                    dataSetName: "enemies"
                    editorSource: "Edit_Enemies.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("Troops")
                    hint: qsTr("Data for enemy groups. The unit in which they appear in the game.")
                    templateName: "Troop"
                    dataSetName: "troops"
                    editorSource: "Edit_Troops.qml"
                    maximumNumberOfItems: 10000 // Changed to 10k
                }
                Tab_DBStandard {
                    title: qsTr("States")
                    hint: qsTr("Data influencing character status in various ways.")
                    templateName: "State"
                    dataSetName: "states"
                    editorSource: "Edit_States.qml"
                }
                Tab_DBStandard {
                    title: qsTr("Animations")
                    hint: qsTr("Data used for various visual effects.")
                    templateName: "Animation"
                    dataSetName: "animations"
                    editorSource: "Edit_Animations.qml"
                }
                Tab_DBStandard {
                    title: qsTr("Tilesets")
                    hint: qsTr("Data defining the behavior of tilesets for maps.")
                    templateName: "Tileset"
                    dataSetName: "tilesets"
                    editorSource: "Edit_Tilesets.qml"
                }
                Tab_DBStandard {
                    title: qsTr("Common Events")
                    hint: qsTr("Data for commonly used events.")
                    templateName: "CommonEvent"
                    dataSetName: "commonEvents"
                    editorSource: "Edit_CommonEvents.qml"
                }
                Tab_DBSystem {
                    title: qsTr("System")
                    hint: qsTr("Basic configuration of the entire game.")
                }
                Tab_DBTypes {
                    title: qsTr("Types")
                    hint: qsTr("Names of elements, skill types, weapon types, armor types, and equipment types.")
                }
                Tab_DBTerms {
                    title: qsTr("Terms")
                    hint: qsTr("Text data such as command and parameter names.")
                }

                onCurrentIndexChanged: {
                    if (!sideTabBar.activeFocus && currentIndex >= 0) {
                        nextItemInFocusChain().forceActiveFocus();
                    }
                    sideTabBar.currentIndex = currentIndex;
                    deactivateInvisibleTabs();
                }

                // For performance reasons
                function deactivateInvisibleTabs() {
                    for (var i = 0; i < count; i++) {
                        if (i !== currentIndex) {
                            getTab(i).active = false;
                        }
                    }
                    TkoolAPI.collectGarbage();
                }
            }
        }

        property bool okPressed: false

        Component.onCompleted: {
            sideTabBar.currentIndex = currentTabIndex;
        }
        Component.onDestruction: {
            currentTabIndex = sideTabBar.currentIndex;
            if (okPressed) {
                DataManager.backupDatabase();
            } else {
                DataManager.restoreDatabase();
            }
            DataManager.updateGameTitle();
        }
        onOk: {
            DataManager.databaseModified = true;
            okPressed = true;
            TutorialManager.onOkDialog("DatabaseMain", root);
        }
        onApply: {
            DataManager.databaseModified = true;
            DataManager.backupDatabase();
            applyEnabled = false;
        }
        onCancel: {
            if (applyEnabled) {
                dialogBox.openDiscardConfirm(function() {
                    root.emitCancel();
                });
            } else {
                root.emitCancel();
            }
            TutorialManager.onCancelDialog("DatabaseMain", root);
        }
        onClosing: {
            if (applyEnabled) {
                close.accepted = false;
                dialogBox.openDiscardConfirm(function() {
                    root.emitClose();
                });
            }
        }

        MessageBox {
            id: discardConfirmBox
            iconType: "warning"
            useYesNo: true
            message: qsTr("Discard changes to the database?");

            property var callback
            property bool result

            resources: Timer {
                id: callbackTimer
                interval: 1
                onTriggered: discardConfirmBox.callback(discardConfirmBox.result)
            }

            onYes: {
                result = true;
                callbackTimer.start();
            }

            onNo: {
                result = false;
                callbackTimer.start();
            }
        }

        function openDiscardConfirm(callback) {
            discardConfirmBox.callback = function(answer) {
                if (answer) {
                    callback();
                }
            }
            discardConfirmBox.open();
        }
    }

    onInit: {
        TkoolAPI.collectGarbage();
    }
}
