import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"
import "../Scripts/JsonTemplates.js" as JsonTemplates

ControlsColumn {
    id: root

    property var object: dataObject

    property int mapId: 0
    property int maxEventPages: 30
    property string clipboardFormat: "EventPage"

    property alias currentPageIndex: tabView.currentIndex

    DialogBoxHelper { id: helper }

    Row {
        spacing: 20

        ControlsRow {
            ObjTextField {
                member: "name"
                title: qsTr("Name")
                hint: qsTr("Name of the event.")
            }

            ObjTextField {
                member: "note"
                title: Constants.noteTitle
                hint: Constants.noteHint
                itemWidth: 500

                contextMenu: TextEditPopupMenu {
                    MenuSeparator { }
                    MenuItem_PluginHelpEverywhere { }
                }
            }
        }

        Layout_EventPageButtons {
            horizontal: true
            clipboardFormat: root.clipboardFormat
            creationEnabled: tabView.count < maxEventPages
            onCreate: createPage()
            onCopy: copyPage()
            onPaste: pastePage()
            onRemove: removePage()
            onClear: clearPage()
        }
    }

    TabView {
        id: tabView
        width: 1216
        height: 802

        TabColumn {
            Layout_EventPage {
                id: eventPageEditor
                mapId: root.mapId
            }
        }

        onCurrentIndexChanged: {
            updateCurrentPage();
        }
    }

    onObjectChanged: {
        updateAll();
    }

    function updateAll() {
        if (object) {
            updatePages();
            updateCurrentPage();
        }
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
        eventPageEditor.dataObject = getCurrentEventPage();
    }

    function getEventPageArray() {
        return DataManager.getObjectValue(object, "pages", []);
    }

    function getCurrentEventPage() {
        var eventPageArray = getEventPageArray();
        return eventPageArray[currentPageIndex];
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
        return JSON.parse(JsonTemplates.EventPage);
    }
}
