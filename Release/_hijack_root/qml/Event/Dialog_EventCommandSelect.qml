import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root

    title: qsTr("Event Commands")

    property int eventCode: 101
    property var eventData
    property int troopId: 0

    resources: [
        Timer {
            id: windowCloser
            interval: 1
            onTriggered: root.close()
        }
    ]

    DialogBox {
        id: dialogBox

        okEnabled: false
        okVisible: false
        applyVisible: false

        signal triggered(var code)

        onInit: {
            for (var i = 0; i < tabView.count; i++) {
                var tab = tabView.getTab(i);
                tab.active = true;
                if (searchAndFocusEventButton(tab.item, DataManager.lastEventCode)) {
                    tabView.currentIndex = i;
                    break;
                }
            }
        }

        TabView {
            id: tabView
            width: OneMakerMVSettings.getSetting("eventCommandSelect", "width") // [OneMaker MV] - Changed to use Constants width
            height: 596 + 30 // [OneMaker MV] - Add + 30 to account for increased height for Control Self Variable
            visible: !OneMakerMVSettings.getSetting("eventCommandSelect", "combinedEnabled") // [OneMaker MV] - Added visibility based on Constants

            Tab {
                title: " 1 "
                GroupBoxRow {
                    anchors.fill: parent
                    anchors.margins: 8
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Message")
                            codeList: [101, 102, 103, 104, 105]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Game Progression")
                            codeList: [121, 122, 123, 357, 124] // [OneMaker MV] - Add Control Self Variable
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Flow Control")
                            codeList: [111, 358, 112, 113, 115, 117, 118, 119, 108]// [OneMaker MV] - Add Switch Statement
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Party")
                            codeList: [125, 126, 127, 128, 129]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Actor")
                            codeList: [311, 312, 326, 313, 314, 315, 316, 317, 318, 319, 320, 321, 324, 325]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                }
            }
            Tab {
                title: " 2 "
                GroupBoxRow {
                    anchors.fill: parent
                    anchors.margins: 8
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Movement")
                            codeList: [201, 202, 203, 204, 205, 206]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Character")
                            codeList: [211, 216, 217, 212, 213, 214]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Picture")
                            codeList: [231, 232, 233, 234, 235]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Timing")
                            codeList: [230]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Screen")
                            codeList: [221, 222, 223, 224, 225, 236]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Audio & Video")
                            codeList: [1002, 241, 242, 243, 244, 245, 246, 249, 250, 251, 261]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                }
            }
            Tab {
                title: " 3 "
                GroupBoxRow {
                    anchors.fill: parent
                    anchors.margins: 8
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Scene Control")
                            codeList: [301, 302, 303, 351, 352, 353, 354]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("System Settings")
                            codeList: [132, 133, 139, 140, 134, 135, 136, 137, 138, 322, 323]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Map")
                            codeList: [281, 282, 283, 284, 285]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Battle")
                            codeList: [331, 332, 342, 333, 334, 335, 336, 337, 339, 340]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Advanced")
                            codeList: [355, 356]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                }
            }
            // [OneMaker MV] - Added new Tab for custom commands
            Tab {
                title: " 4 "
                GroupBoxRow {
                    anchors.fill: parent
                    anchors.margins: 8
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Custom Advanced")
                            codeList: [1001, 1003, 1004]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                }
            }
        }

        TabView {
            id: tabView1
            width: OneMakerMVSettings.getSetting("eventCommandSelect", "width") // [OneMaker MV] - Changed to use Constants width
            height: 596 + 30 // [OneMaker MV] - Add + 30 to account for increased height
            visible: OneMakerMVSettings.getSetting("eventCommandSelect", "combinedEnabled") // [OneMaker MV] - Added visibility based on Constants

            // [OneMaker MV] - Removed the other Tab's and converted it into one giant tab if the Single Event Command Select Page Constant is enabled
            Tab {
                title: " Combined "
                GroupBoxRow {
                    anchors.fill: parent
                    anchors.margins: 8
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Message")
                            codeList: [101, 102, 103, 104, 105]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Game Progression")
                            codeList: [121, 122, 123, 357, 124] // [OneMaker MV] - Add Control Self Variable
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Flow Control")
                            codeList: [111, 358, 112, 113, 115, 117, 118, 119, 108]// [OneMaker MV] - Add Switch Statement
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Party")
                            codeList: [125, 126, 127, 128, 129]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Actor")
                            codeList: [311, 312, 326, 313, 314, 315, 316, 317, 318, 319, 320, 321, 324, 325]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Movement")
                            codeList: [201, 202, 203, 204, 205, 206]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Character")
                            codeList: [211, 216, 217, 212, 213, 214]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Picture")
                            codeList: [231, 232, 233, 234, 235]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Timing")
                            codeList: [230]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Screen")
                            codeList: [221, 222, 223, 224, 225, 236]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Audio & Video")
                            codeList: [1002, 241, 242, 243, 244, 245, 246, 249, 250, 251, 261]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Scene Control")
                            codeList: [301, 302, 303, 351, 352, 353, 354]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("System Settings")
                            codeList: [132, 133, 139, 140, 134, 135, 136, 137, 138, 322, 323]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Map")
                            codeList: [281, 282, 283, 284, 285]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Battle")
                            codeList: [331, 332, 342, 333, 334, 335, 336, 337, 339, 340]
                            onTriggered: dialogBox.triggered(code)
                        }
                        EventCommandGroup {
                            title: qsTr("Advanced")
                            codeList: [355, 356]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                    // [OneMaker MV] - Added new Group for custom commands
                    GroupBoxColumn {
                        EventCommandGroup {
                            title: qsTr("Custom Advanced")
                            codeList: [1001, 1003, 1004]
                            onTriggered: dialogBox.triggered(code)
                        }
                    }
                }
            }
        }

        Dialog_EventCommand {
            id: commandDialog
            troopId: root.troopId
            onOk: {
                root.eventData = eventData;
                root.ok();
                windowCloser.start();
            }
        }

        onTriggered: {
            eventCode = code;
            DataManager.lastEventCode = code;
            if (EventCommands.flag(code) === 0) {
                makeSimpleEventData();
                root.ok();
                root.close();
            } else {
                commandDialog.eventCode = eventCode;
                commandDialog.eventData = null;
                commandDialog.open();
            }
        }

        function searchAndFocusEventButton(item, eventCode) {
            for (var i = 0; i < item.children.length; i++) {
                var child = item.children[i];
                if (child.eventCode === eventCode) {
                    root.firstFocusItem = child;
                    return true;
                }
                if (searchAndFocusEventButton(child, eventCode)) {
                    return true;
                }
            }
            return false;
        }

        function makeSimpleEventData() {
            root.eventData = [{ code: eventCode, indent: 0, parameters: [] }];
            if (eventCode === 112) {    // Loop
                root.eventData.push({ code: 0, indent: 1, parameters: [] });
                root.eventData.push({ code: 413, indent: 0, parameters: [] });
            }
        }
    }
}
