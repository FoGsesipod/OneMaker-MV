import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Dialogs"
import "../Map"
import "../Singletons"

ListBox {
    id: root

    headerVisible: false
    multiSelect: true
    showSelectionAlways: false
    selectBottomByExtraRows: true
    currentIndex: 0
    wantReturn: true

    property var list: []
    property string clipboardFormat: "EventCommand"
    property int troopId: 0

    // [OneMaker MV] - Detect if Improved Event Test plugin is enabled
    property bool improveEventTest: false

    // [OneMaker MV] - Add Cursor Map X/Y for Event Test Improvement.
    property int mapX: 0
    property int mapY: 0

    readonly property var eventCodeThreshold: [400, 1000] // [OneMaker MV] - allow codes above 1000
    readonly property var currentItem: list[selectionStart]
    readonly property int currentCode: currentItem ? currentItem.code : eventCodeThreshold[0]
    readonly property bool validItemSelected: currentCode > 0 && currentCode < eventCodeThreshold[0] || currentCode > eventCodeThreshold[1] // [OneMaker MV] - Append eventCodeThreshold Chanes
    readonly property bool creationEnabled: currentCode < eventCodeThreshold[0] || currentCode > eventCodeThreshold[1] // [OneMaker MV] - Append eventCodeThreshold Chanes

    property int maxItemWidth: 0

    ListBoxColumn {
        role: "text"
        width: Math.max(viewport.width, root.maxItemWidth)
    }

    model: ListModel {
        id: listModel
    }

    Palette { id: pal }

    style: CustomScrollViewStyle {
        property color textColor: control.enabled ? pal.normalText : pal.disabledText
        property color highlightedTextColor: control.enabled ? pal.selectedText : pal.disabledText

        property Component headerDelegate: ListBoxHeader {
        }

        property Component rowDelegate: ListBoxRow {
        }

        property Component itemDelegate: itemDelegate

        Component {
            id: itemDelegate
            Item {
                property string text: styleData.value || ""
                property bool selected: styleData.selected

                clip: true

                Text {
                    id: text1
                    width: parent.width
                    anchors.leftMargin: 12
                    anchors.left: parent.left
                    anchors.right: parent.right
                    horizontalAlignment: styleData.textAlignment
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    elide: styleData.elideMode
                    opacity: control.enabled ? 1 : 0.5
                    font.family: pal.fixedFont
                    font.pixelSize: pal.fontSize
                    textFormat: Text.PlainText
                    Text {
                        id: text2
                        anchors.fill: parent
                        font: parent.font
                        textFormat: Text.PlainText
                        anchors.leftMargin: parent.paintedWidth
                        Text {
                            id: text3
                            anchors.fill: parent
                            font: parent.font
                            textFormat: Text.PlainText
                            anchors.leftMargin: parent.paintedWidth
                            Text {
                                id: text4
                                anchors.fill: parent
                                font: parent.font
                                textFormat: Text.PlainText
                                anchors.leftMargin: parent.paintedWidth
                                Text {
                                    id: text5
                                    anchors.fill: parent
                                    font: parent.font
                                    textFormat: Text.PlainText
                                    anchors.leftMargin: parent.paintedWidth
                                }
                            }
                        }
                    }
                }

                onTextChanged: update()
                onSelectedChanged: update()

                function realColor(color) {
                    return ThemeManager.currentTheme.eventColorMap[color] || color;
                }

                function update() {
                    var array = text.split("\t");
                    var colors = [];
                    colors.push(textColor);
                    colors.push(realColor(array[1] || ""));
                    colors.push(realColor(array[3] || ""));
                    colors.push(realColor(array[5] || ""));
                    colors.push(realColor(array[7] || ""));
                    if (selected) {
                        for (var i = 0; i < colors.length; i++) {
                            if (colors[i] !== "transparent") {
                                colors[i] = highlightedTextColor;
                            }
                        }
                    }
                    text1.color = colors[0];
                    text2.color = colors[1];
                    text3.color = colors[2];
                    text4.color = colors[3];
                    text5.color = colors[4];
                    text1.text = array[0] || "";
                    text2.text = array[2] || "";
                    text3.text = array[4] || "";
                    text4.text = array[6] || "";
                    text5.text = array[8] || "";
                }
            }
        }
    }

    resources: Loader {
        id: sizeHintLoader
        sourceComponent: Text {
            font.family: pal.fixedFont
            font.pixelSize: pal.fontSize
        }
    }

    EventCommandTexts {
        id: commandTexts
        troopId: root.troopId
    }

    Dialog_EventCommand {
        id: commandDialog
        locator: root
        troopId: root.troopId
        onOk: replace(eventData)
    }

    Dialog_EventCommandSelect {
        id: commandListDialog
        locator: root
        troopId: root.troopId
        onOk: insert(eventData)
    }

    Dialog_GamePlayer {
        id: gamePlayer
        eventTest: true
    }

    // [OneMaker MV] - Add Dialog Location for Event Test selection
    Dialog_Location {
        id: dialogLocation
        title: qsTr("Select Player Location")
        needMapSelection: false

        onOk: {
            root.mapX = mapX;
            root.mapY = mapY;
            runTest();
        }
    }

    DialogBoxHelper { id: helper }

    contextMenu: StandardPopupMenu {
        id: contextMenu
        owner: root

        clipboardFormat: root.clipboardFormat
        validItemSelected: root.validItemSelected
        createEnabled: root.creationEnabled
        editEnabled : isSingleCommand()
        returnForCreate: true
        ellipsisForCreate: true

        useEdit: true
        useNew: true
        useCut: true
        useCopy: true
        usePaste: true
        useDelete:  true
        useSelectAll: true

        onEditNew: root.create()
        onEditEdit: root.edit()
        onEditCopy: root.copy()
        onEditPaste: root.paste()
        onEditDelete: root.remove()
        onEditSelectAll: root.selectAll()

        MenuSeparator {
        }

        MenuItem {
            id: menuCopyAsText
            text: qsTr("Copy as Text")
            enabled: root.validItemSelected
            onTriggered: {
                root.copyAsText();
                TutorialManager.onActionTriggered("CopyAsText", this);
            }
        }

        MenuItem {
            id: menuCopyAsHTML
            text: qsTr("Copy as HTML")
            enabled: root.validItemSelected
            onTriggered: {
                root.copyAsHTML();
                TutorialManager.onActionTriggered("CopyAsHTML", this);
            }
        }

        MenuSeparator {
        }

        MenuItem {
            id: menuTest
            text: qsTr("Test")
            shortcut: "Ctrl+R"
            enabled: root.validItemSelected
            onTriggered: {
                root.test();
                TutorialManager.onActionTriggered("Test", this);
            }
        }
    }

    onListChanged: {
        refresh();
        selectOne(0);
        updateCommandSelection();
    }

    onSelectionChanged: {
        updateCommandSelection();
        contextMenu.updateMenuItems();
    }

    onActiveFocusChanged: {
        contextMenu.updateMenuItems();
    }

    onMoveCursorUp: {
        var index = currentIndex;
        while (index > 0 && (list[index].code >= eventCodeThreshold[0] || list[index].code <= eventCodeThreshold[1])) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
            index--;
        }
        currentIndex = index;
    }

    onMoveCursorDown: {
        var index = currentIndex;
        while (index < list.length - 1 && (list[index].code >= eventCodeThreshold[0] || list[index].code <= eventCodeThreshold[1])) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
            index++;
        }
        currentIndex = index;
    }

    onDoubleClicked: {
        if (creationEnabled) {
            create();
        }
    }

    function refresh() {
        listModel.clear();
        for (var i = 0; i < list.length; i++) {
            insertModelItem(i);
        }
        updateMaxItemWidth();
    }

    function updateAll() {
        for (var i = 0; i < list.length; i++) {
            updateModelItem(i);
        }
        updateMaxItemWidth();
    }

    function insertModelItem(index) {
        listModel.insert(index, { text: commandTexts.make(list[index]) });
    }

    function updateModelItem(index) {
        listModel.get(index).text = commandTexts.make(list[index]);
    }

    function updateCommandSelection() {
        var minIndex = Math.min(root.currentIndex, root.currentAnchor);
        var maxIndex = Math.max(root.currentIndex, root.currentAnchor);

        minIndex = Math.min(minIndex, list.length - 1);
        maxIndex = Math.min(maxIndex, list.length - 1);

        if (minIndex >= 0) {
            var i;

            var minIndent = Number.MAX_VALUE;
            for (i = minIndex; i <= maxIndex; i++) {
                if (list[i].indent < minIndent) {
                    minIndent = list[i].indent;
                }
            }

            var startIndex = -1;
            for (i = minIndex; i <= maxIndex; i++) {
                if ((list[i].code < eventCodeThreshold[0] || list[i].code > eventCodeThreshold[1]) && list[i].indent === minIndent) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
                    startIndex = i;
                    break;
                }
            }

            var endIndex = startIndex;
            for (i = maxIndex; i >= minIndex; i--) {
                if (!(i < list.length - 1 && list[i].code === 0) &&
                        (list[i].code < eventCodeThreshold[0] || list[i].code > eventCodeThreshold[1]) && list[i].indent === minIndent) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
                    endIndex = i;
                    while (endIndex < list.length - 2) {
                        var code = list[endIndex + 1].code;
                        var indent = list[endIndex + 1].indent;
                        if (indent < minIndent) {
                            break;
                        }
                        if (indent === minIndent && (code < eventCodeThreshold[0] || code > eventCodeThreshold[1])) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
                            break;
                        }
                        endIndex++;
                    }
                    break;
                }
            }

            if (endIndex === list.length - 1 &&
                (root.currentIndex < endIndex || startIndex < endIndex)) {
                endIndex = list.length - 2;
            }

            forceSelectionRange(startIndex, endIndex);
        }
    }

    function isSingleCommand() {
        if (!currentItem) {
            return false;
        }
        var indent = currentItem.indent;
        for (var i = selectionStart + 1; i <= selectionEnd; i++) {
            if ((list[i].code < eventCodeThreshold[0] || list[i].code > eventCodeThreshold[1]) && list[i].indent === indent) {  // [OneMaker MV] - Append eventCodeThreshold Chanes
                return false;
            }
        }
        return true;
    }

    function edit() {
        var editData = list.slice(selectionStart, selectionEnd + 1);
        var code = editData[0].code;
        if (EventCommands.flag(code) === 1) {
            commandDialog.eventCode = code;
            commandDialog.eventData = editData;
            commandDialog.open();
        }
    }

    function create() {
        commandListDialog.open();
    }

    function insert(data) {
        if (data && data[0]) {
            insertEventData(data);
            updateAll();
            if (data[0].code === 101) { // Show Text
                // For batch entry
                root.selectOne(selectionStart + data.length);
            } else {
                root.selectOne(selectionStart + 1);
                moveCursorDown();
            }
        }
    }

    function copy() {
        var clipData = list.slice(selectionStart, selectionEnd + 1);
        Clipboard.setData(clipboardFormat, JSON.stringify(clipData));
    }

    function paste() {
        var clipData = JSON.parse(Clipboard.getData(clipboardFormat));
        if (clipData) {
            var baseIndex = selectionStart;
            insertEventData(clipData);
            root.selectOne(baseIndex + clipData.length);
        }
    }

    function remove() {
        var count = selectionEnd - selectionStart + 1;
        root.selectOne(selectionStart);
        list.splice(selectionStart, count);
        listModel.remove(selectionStart, count);
        root.reselect();
        updateMaxItemWidth();
    }

    function selectAll() {
        root.selectRange(0, list.length - 1);
    }

    function replace(data) {
        if (data && data[0]) {
            var baseIndex = selectionStart;
            remove();
            insertEventData(data);
            updateAll();
            root.selectOne(baseIndex);
        }
    }

    function insertEventData(data) {
        if (data && data[0]) {
            var baseIndex = selectionStart;
            var indentOffset = list[baseIndex].indent - data[0].indent;
            for (var i = 0; i < data.length; i++) {
                var listIndex = baseIndex + i;
                list.splice(listIndex, 0, data[i]);
                list[listIndex].indent += indentOffset;
                insertModelItem(listIndex);
            }
            helper.setModified();
        }
        updateMaxItemWidth();
    }

    function updateMaxItemWidth() {
        maxItemWidth = 0;
        var sizeHint = sizeHintLoader.item;
        if (sizeHint) {
            for (var i = 0; i < listModel.count; i++) {
                var item = listModel.get(i);
                var array = item.text.split("\t");
                var combinedText = "";
                combinedText += array[0] || "";
                combinedText += array[2] || "";
                combinedText += array[4] || "";
                combinedText += array[6] || "";
                sizeHint.text = combinedText;
                var width = sizeHint.width + 20;
                if (maxItemWidth < width) {
                    maxItemWidth = width;
                }
            }
        }
    }

    function test() {
        // [OneMaker MV] - Detect if the Event Test Fixes plugin is installed
        var dataArray = DataManager.plugins;

        for (var i = 0; i < dataArray.length; i++) {
            if (dataArray[i].name === "Geo_ImprovedEventTest" && dataArray[i].status) {
                dialogLocation.mapId = mapId;
                dialogLocation.mapX = object["x"];
                dialogLocation.mapY = object["y"];
                dialogLocation.open();
                improveEventTest = true;
                return;
            }
        }

        runTest();
    }

    // [OneMaker MV] - Separate gamePlayer.open() to another function for player selection
    function runTest() {
        var data = list.slice(selectionStart, selectionEnd + 1);

        // [OneMaker MV] - Make Extra Event Test information if the plugin was detected
        if (improveEventTest) {
            var xy = [mapX, mapY];
            var extraData = {EventId: eventId, MapId: mapId, X: xy[0], Y: xy[1]}
            DataManager.saveDataFile("Test_EventExtra.json", extraData);
            improveEventTest = false;
        }
        
        DataManager.saveTestData();
        DataManager.saveTestEvent(data);
        gamePlayer.open();
    }

    function copyAsText() {
        var data = convertToText(list.slice(selectionStart, selectionEnd + 1));
        var text = data.plainText.join("\n");
        var html = '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><pre>' + data.html.join("<br>") + "</pre>";
        TkoolAPI.setClipboardRichText(text, html);
    }

    function copyAsHTML() {
        var data = convertToText(list.slice(selectionStart, selectionEnd + 1));
        var html = '<pre>' + data.html.join("\n") + "</pre>";
        TkoolAPI.setClipboardText(html);
    }

    function escapeHTML(unsafe) {
        var entityMap = {
           "&": "&amp;",
           "<": "&lt;",
           ">": "&gt;",
           '"': '&quot;',
           "'": '&#39;',
           "/": '&#x2F;'
         };

         return String(unsafe).replace(/[&<>"'\/]/g, function (s) {
             return entityMap[s];
         });
    }

    function convertToText(items) {
        var plainText = [];
        var html = [];
        items.forEach(function(i) {
            var text = commandTexts.make(i);
            var array = text.split("\t");
            var colors = [];
            var texts = [];
            colors.push("black");
            colors.push(array[1] || "black");
            colors.push(array[3] || "black");
            colors.push(array[5] || "black");
            colors.push(array[7] || "black");

            texts.push(array[0] || "");
            texts.push(array[2] || "");
            texts.push(array[4] || "");
            texts.push(array[6] || "");
            texts.push(array[8] || "");

            plainText.push(texts.map(function(item, index) {
                if (colors[index] === "transparent") {
                    return item.replace(/[\u0000-\u00FF]/g, "\u0020").replace(/[^ ]/g, "\u3000");
                }
                return item;
            }).join(""));

            html.push(texts.map(function(item, index) {
                if (item) {
                    var color = colors[index] === "transparent" ? "white" : colors[index];
                    return "<font color=\"" + escapeHTML(color) + "\">" + escapeHTML(item) + "</font>";
                }
                return "";
            }).join(""));
        });

        return { plainText: plainText, html: html }
    }

    Component.onCompleted: {
        updateMaxItemWidth();
    }

    Component.onDestruction: {
        DataManager.removeTestData();
        DataManager.removeDataFile("Test_EventExtra.json"); // [OneMaker MV] - Remove Test Event Extra
        DataManager.removeTestEvent();
        
    }
}
