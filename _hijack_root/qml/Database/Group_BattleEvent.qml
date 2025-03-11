import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Dialogs"
import "../Event"
import "../Singletons"
import "../Scripts/JsonTemplates.js" as JsonTemplates

GroupBox {
    id: root

    title: qsTr("Battle Event")
    hint: qsTr("Events run during battle. Set up dialogs with the enemy, etc.")

    property int troopId: 0
    property var object: dataObject

    property int buttonWidth: 100
    property int buttonHeight: 56

    property int maxEventPages: 30 // [OneMaker MV] - Increased by 10
    property string clipboardFormat: "BattleEventPage"

    property alias currentPageIndex: tabView.currentIndex

    DialogBoxHelper { id: helper }

    ControlsRow {
        Layout_EventPageButtons {
            anchors.top: parent.top
            anchors.topMargin: 24
            horizontal: false
            clipboardFormat: root.clipboardFormat
            creationEnabled: tabView.count < maxEventPages
            onCreate: createPage()
            onCopy: copyPage()
            onPaste: pastePage()
            onRemove: removePage()
            onClear: clearPage()
        }

        TabView {
            id: tabView
            width: 630 + WindowSizes.defaultWidthIncrease // [OneMaker MV] - Window Increased
            height: 326 + WindowSizes.alternativeHeightIncrease // [OneMaker MV] - Window Increased

            TabColumn {
                spacing: 12

                Row {
                    spacing: 20
                    ObjEllipsisBox {
                        id: conditions
                        title: qsTr("Conditions")
                        hint: qsTr("Conditions to start the event. The contents will be run only when all the set conditions have been met. If there are multiple event pages meeting conditions, the contents will be run in order from lower to higher numbered page.")
                        horizontal: true
                        itemWidth: 348
                        onClicked: conditionsDialog.open();
                    }
                    ObjComboBox {
                        id: span
                        title: qsTr("Span")
                        hint: qsTr("Interval during which the event contents are allowed to run.<br>[Battle] Run only once in the battle.<br>[Turn] Run only once per turn.<br>[Moment] Repeat while the conditions met.")
                        horizontal: true
                        model: [ qsTr("Battle"), qsTr("Turn"), qsTr("Moment") ]
                        itemWidth: 100
                        onCurrentIndexChanged: updateSpan()
                    }
                }
                EventCommandListBox {
                    id: eventListBox
                    width: 612 + WindowSizes.defaultWidthIncrease // [OneMaker MV] - Window Increased
                    height: 242 + WindowSizes.alternativeHeightIncrease // [OneMaker MV] - Window Increased
                    troopId: root.troopId
                }
            }

            onCurrentIndexChanged: {
                updateCurrentPage();
            }
        }
    }

    Dialog_BattleConditions {
        id: conditionsDialog
        locator: root
        troopId: root.troopId
        groupTitle: conditions.title
        groupHint: conditions.hint

        onInit: {
            var eventPage = getCurrentEventPage();
            dataObject = DataManager.clone(eventPage.conditions);
        }

        onOk: {
            var eventPage = getCurrentEventPage();
            eventPage.conditions = dataObject;
            helper.setModified();
            updateCurrentPage();
        }
    }

    onObjectChanged: {
        updateAll();
    }

    function updateAll() {
        updatePages();
        updateCurrentPage();
    }

    function updatePages() {
        var eventPageArray = getEventPageArray();
        var maxTabs = eventPageArray.length;
        while (tabView.count < maxTabs) {
            var tabId = tabView.count + 1;
            var tabTitle = " " + tabId + " ";
            tabView.addTab(tabTitle);
        }
        while (tabView.count > maxTabs) {
            tabView.removeTab(tabView.count - 1);
        }
    }

    function updateCurrentPage() {
        var eventPage = getCurrentEventPage();
        if (eventPage) {
            span.currentIndex = eventPage.span;
            conditions.text = makeConditionsText(eventPage);
            eventListBox.list = eventPage.list;
        } else {
            eventListBox.list = [];
        }
    }

    function getEventPageArray() {
        return DataManager.getObjectValue(object, "pages", [null]);
    }

    function getCurrentEventPage() {
        var eventPageArray = getEventPageArray();
        return eventPageArray[currentPageIndex];
    }

    function makeConditionsText(eventPage) {
        var c = eventPage.conditions
        var text = "";
        if (c.turnEnding) {
            text += qsTr("Turn End");
        }
        if (c.turnValid) {
            if (text.length) {
                text += ", ";
            }
            text += qsTr("Turn") + " ";
            if (c.turnA !== 0) {
                text += c.turnA;
                if (c.turnB !== 0) {
                    text += "+";
                }
            }
            if (c.turnB !== 0) {
                text += c.turnB + "*X";
            }
            if (c.turnA === 0 && c.turnB === 0) {
                text +="0";
            }
        }
        if (c.enemyValid) {
            if (text.length) {
                text += ", ";
            }
            text += qsTr("Enemy HP") + " ";
            text += "(" + (c.enemyIndex + 1) + ") <= ";
            text += c.enemyHp + "%";
        }
        if (c.actorValid) {
            if (text.length) {
                text += ", ";
            }
            text += qsTr("Actor HP") + " ";
            text += "(" + c.actorId + ") <= ";
            text += c.actorHp + "%";
        }
        if (c.switchValid) {
            if (text.length) {
                text += ", ";
            }
            text += "{" + DataManager.switchNameOrId(c.switchId) + "}";
        }
        if (!text.length) {
            text = qsTr("Don't Run");
        }
        return text;
    }

    function updateSpan() {
        var eventPage = getCurrentEventPage();
        if (eventPage && eventPage.span !== span.currentIndex) {
            eventPage.span = span.currentIndex;
            helper.setModified();
        }
    }

    function createPage() {
        var eventPageArray = getEventPageArray();
        var eventPage = createEmptyPage();
        eventPageArray.splice(currentPageIndex + 1, 0, eventPage);
        helper.setModified();
        updateAll();
        currentPageIndex++;
    }

    function copyPage() {
        var eventPage = getCurrentEventPage();
        Clipboard.setData(clipboardFormat, JSON.stringify(eventPage));
    }

    function pastePage() {
        if (Clipboard.format === clipboardFormat) {
            var eventPageArray = getEventPageArray();
            var eventPage = JSON.parse(Clipboard.getData(clipboardFormat));
            eventPageArray.splice(currentPageIndex + 1, 0, eventPage);
            helper.setModified();
            updateAll();
            currentPageIndex++;
        }
    }

    function removePage() {
        var eventPageArray = getEventPageArray();
        eventPageArray.splice(currentPageIndex, 1);
        helper.setModified();
        updateAll();
    }

    function clearPage() {
        var eventPageArray = getEventPageArray();
        var eventPage = createEmptyPage();
        eventPageArray.splice(currentPageIndex, 1, eventPage);
        helper.setModified();
        updateAll();
    }

    function createEmptyPage() {
        return JSON.parse(JsonTemplates.BattleEventPage);
    }
}
