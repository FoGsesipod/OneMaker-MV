import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Event"
import "../Singletons"
import "../Scripts/JsonTemplates.js" as JsonTemplates

ScrollView {
    id: root

    property int mapId: 0
    property int tilesetId: 0
    property var tilesetNames: []
    property var tilesetFlags: []
    property string parallaxName
    property bool parallaxShow
    property real tileScale: 1
    property int clickMouseX
    property int clickMouseY

    property var draggingEvent: null

    property alias editMode: body.editMode
    property alias drawingTool: body.drawingTool
    property alias regionMode: body.regionMode
    property alias cursorRect: body.cursorRect

    property alias mapSize: body.mapSize
    property alias mapData: body.mapData
    property alias penSize: body.penSize
    property alias penData: body.penData

    property alias screenGrid: body.screenGrid
    property alias screenGridSize: body.screenGridSize

    readonly property bool projectOpened: DataManager.projectOpened
    readonly property Item _body: body

    signal mapModified(var rect)
    signal tilePicked()
    signal refresh()
    signal leftPressed()
    signal rightClicked()
    signal doubleClicked()
    signal eventDropped()
    signal zoomInRequested()
    signal zoomOutRequested()

    Rectangle {
        Palette { id: pal }
        anchors.fill: parent
        color: pal.outsideArea
        clip: true
        Checkerboard {
            width: root.flickableItem.contentWidth
            height: root.flickableItem.contentHeight
        }
    }

    Flickable {
        id: flickable

        interactive: false
        contentWidth: body.width
        contentHeight: body.height
        boundsBehavior: Flickable.StopAtBounds

        MapEditorBody {
            id: body
            viewport: Qt.rect(flickable.contentX, flickable.contentY, root.width, root.height);
            projectUrl: DataManager.projectUrl
            tilesetNames: root.tilesetNames
            tilesetFlags: root.tilesetFlags

            onModified: root.mapModified(rect)
            onTilePicked: root.tilePicked()
            onEventDropped: root.eventDropped()
            visible: width > 0 && height > 0
            clip: true

            Image {
                property string imageName: "map" + DataManager.makeIdText(root.mapId, 2)
                property string folder: DataManager.projectUrl + "scaled"
                source: root.mapId > 0 ? folder + "/" + encodeURIComponent(imageName) + ".png" : ""
                fillMode: Image.Tile
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignTop
                x: (body.width - width) / 2
                y: (body.height - height) / 2
                width: body.width / scale
                height: body.height / scale
                scale: body.tileScale
                visible: true
                z: -1
            }

            Item {
                anchors.fill: parent
                Repeater {
                    id: startPanelRepeater
                    model: 4
                    EventPanel {
                        mapId: root.mapId
                        eventId: -4 + index
                        tileSize: body.tileSize
                        tileScale: body.tileScale
                    }
                }
                Repeater {
                    id: eventPanelRepeater
                    EventPanel {
                        mapId: root.mapId
                        eventId: index + 1
                        tileSize: body.tileSize
                        tileScale: body.tileScale
                    }
                }
                Image {
                    // [Workaround] Some video card drivers have a bug with image clipping.
                    // This dummy image prevents their painting issues.
                    source: "./_dummy.png"
                    x: flickable.contentX
                    y: flickable.contentY
                    opacity: 0.1
                }
                opacity: editMode === 1 ? 1 : 0.5
            }

            TileCursor {
                x: parent.cursorPixelRect.x
                y: parent.cursorPixelRect.y
                width: parent.cursorPixelRect.width
                height: parent.cursorPixelRect.height
                visible: editMode === 1 || editMode === -1 || (!scrolling && !scroller.active)
            }

            TileCursor {
                x: parent.dragPoint.x * width
                y: parent.dragPoint.y * height
                width: parent.tileSize.width * parent.tileScale
                height: parent.tileSize.height * parent.tileScale
                visible: parent.eventDragging && draggingEvent
                opacity: 0.5
            }
        }

        MiddleButtonScroller {
            id: scroller
            parent: root.viewport
            width: root.width
            height: root.height
            target: root
            onActiveChanged: body.onMouseExited()
        }

        MouseArea {
            id: mouseAreaView
            parent: root.viewport
            width: root.width
            height: root.height
            acceptedButtons: Qt.NoButton

            onWheel: {
                if (wheel.modifiers & Qt.ControlModifier) {
                    var step = wheel.angleDelta.y / 120;
                    var count = Math.min(Math.abs(step), 10);
                    for(var i = 0; i < count; i++) {
                        if (step > 0)
                            zoomInRequested();
                        else
                            zoomOutRequested();
                    }
                    wheel.accepted = true;
                } else {
                    wheel.accepted = false;
                }
            }
        }

        MouseAreaEx {
            id: mouseArea
            parent: root.viewport
            width: body.width
            height: body.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true

            property bool mouseMoved: false

            Timer {
                id: firstClickTimer
                interval: 200
                onTriggered: mouseArea.onMove()
            }

            Connections {
                target: root
                onScroll: mouseArea.onMove()
            }

            onExited: {
                body.onMouseExited();
                mouseMoved = false;
            }

            onPressed: {
                var point = getClientMousePoint();
                if (mouse.button === Qt.LeftButton) {
                    root.leftPressed();
                    mouse.accepted = body.onLeftPressed(point);
                } else {
                    mouse.accepted = body.onRightPressed(point);
                }
                if (mouse.accepted) {
                    firstClickTimer.restart();
                    if (editMode === 1) {
                        startEventDrag();
                    }
                }
                forceActiveFocus();
                TutorialManager.onMapClicked(getClientMousePoint(), this);
            }

            onReleased: {
                var point = getClientMousePoint();
                if (mouse.button === Qt.LeftButton) {
                    body.onLeftReleased(point);
                } else {
                    body.onRightReleased(point);
                }
                onMove();
            }

            onPositionChanged: {
                mouseMoved = true;
                onMove();
            }

            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    var mfi = mapFromItem(null, 0, 0);
                    clickMouseX = mouseX - mfi.x;
                    clickMouseY = mouseY - mfi.y;
                    root.rightClicked();
                }
                else {
                    TutorialManager.onMapClicked(getClientMousePoint(), this);
                }
            }

            onDoubleClicked: {
                if (mouse.button === Qt.LeftButton) {
                    root.doubleClicked();
                }
            }

            onLongPressed: {
                var mfi = mapFromItem(null, 0, 0);
                clickMouseX = mouseX - mfi.x;
                clickMouseY = mouseY - mfi.y;
                root.rightClicked();
            }

            function onMove() {
                root.updateAutoScrollState(mouseX, mouseY, pressedButtons & Qt.RightButton);
                if (mouseMoved && !firstClickTimer.running) {
                    var point = getClientMousePoint();
                    if (pressedButtons & Qt.LeftButton) {
                        body.onLeftDragged(point);
                    } else if (pressedButtons & Qt.RightButton) {
                        body.onRightDragged(point);
                    } else if (containsMouse) {
                        body.onMouseMove(point);
                    } else {
                        body.onMouseExited();
                    }
                }
            }

            function getClientMousePoint() {
                var cp = mapToItem(body, mouseX, mouseY);
                return Qt.point(cp.x, cp.y);
            }
        }
    }

    onMapIdChanged: {
        if (editMode === 1) {
            body.eraseCursor();
        }
        refresh();
        tilesetNames = tilesetNames;
    }

    onRefresh: {
        var map = DataManager.maps[mapId];
        var info = DataManager.mapInfos[mapId];
        if (map) {
            tilesetId = map.tilesetId;
            body.setMapData(Qt.size(map.width, map.height), map.data);
            scrollToCenter(info.scrollX * tileScale, info.scrollY * tileScale);
            parallaxName = map.parallaxName;
            parallaxShow = map.parallaxShow;
        } else {
            tilesetId = 0;
            body.setMapData(Qt.size(0, 0), []);
        }
        draggingEvent = null;
        refreshAllPanels();
    }

    onTilesetIdChanged: {
        loadTileset();
    }

    onScroll: {
        if (DataManager.mapInfos) {
            var info = DataManager.mapInfos[mapId];
            if (info) {
                info.scrollX = (flickable.contentX + viewport.width / 2) / tileScale;
                info.scrollY = (flickable.contentY + viewport.height / 2) / tileScale;
            }
        }
    }

    onTileScaleChanged: {
        if (DataManager.mapInfos) {
            var info = DataManager.mapInfos[mapId];
            var scrollX = info ? info.scrollX : 0;
            var scrollY = info ? info.scrollY : 0;
            body.tileScale = tileScale;
            scrollToCenter(scrollX * tileScale, scrollY * tileScale);
        } else {
            body.tileScale = tileScale;
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Shift && mouseArea.pressed) {
            mouseArea.onMove();
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Shift && mouseArea.pressed) {
            mouseArea.onMove();
        }
    }

    Keys.onEscapePressed: {
        body.onEscapeKeyPressed();
    }

    function loadTileset() {
        var tileset = DataManager.getDataObject("tilesets", tilesetId);
        tilesetNames = DataManager.getObjectValue(tileset, "tilesetNames", []);
        tilesetFlags = DataManager.getObjectValue(tileset, "flags", []);
    }

    function scrollToCenter(x, y) {
        scrollTo(x - viewport.width / 2, y - viewport.height / 2);
    }

    function updateEventPanelCount() {
        var map = DataManager.maps[mapId];
        if (map && map.events) {
            eventPanelRepeater.model = map.events.length;
        } else {
            eventPanelRepeater.model = 0;
        }
    }

    function refreshEventPanel(eventId) {
        var panel = eventPanelRepeater.itemAt(eventId - 1);
        if (panel) {
            panel.refresh();
        }
    }

    function refreshStartPanels() {
        for (var i = 0; i < startPanelRepeater.count; i++) {
            var panel = startPanelRepeater.itemAt(i);
            if (panel) {
                panel.refresh();
            }
        }
    }

    function refreshAllPanels() {
        updateEventPanelCount();
        for (var i = 0; i < eventPanelRepeater.count; i++) {
            var panel = eventPanelRepeater.itemAt(i);
            if (panel) {
                panel.refresh();
            }
        }
        refreshStartPanels();
    }

    function isShadowMode() {
        return editMode === 0 && drawingTool === 4;
    }

    function cursorPositionText() {
        var rect = cursorRect;
        if (rect.width > 0) {
            var x = rect.x;
            var y = rect.y;
            if (isShadowMode()) {
                x = Math.floor(x / 2);
                y = Math.floor(y / 2);
            }
            return x + "," + y;
        }
        return "";
    }
}
