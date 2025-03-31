import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Layouts"
import "../Singletons"
import "../_OneMakerMV"

FocusScope {
    id: root

    property alias title: hintArea.title
    property alias hint: hintArea.hint
    property alias hintComponent: hintArea.hintComponent

    property var object: dataObject
    property string clipboardFormat: "AnimationCell"
    property bool wantReturn: true

    property int positionType: 0
    property int frameIndex: 0

    property real imageScale: 0.4

    property int currentCellIndex: -1
    property int numberOfCells: 0

    property int maxFrames: 1
    property int maxCells: 1
    property int newPattern: 0
    property int newCellX: 0
    property int newCellY: 0
    property bool cellDragging: false
    property bool cellThrough: false

    readonly property int boxWidth: Constants.animationScreenWidth
    readonly property int boxHeight: Constants.animationScreenHeight
    readonly property int patternSize: Constants.animationPatternSize
    readonly property int gridSize: Constants.animationGridSize
    readonly property var emptyCell: [-1,0,0,0,0,0,0,0]
    readonly property bool playing: player.running

    signal editCell()

    activeFocusOnTab: true

    HintArea {
        id: hintArea
        activeFocusOnPress: true
    }

    Palette { id: pal }
    DialogBoxHelper { id: helper }

    Rectangle {
        anchors.fill: parent
        color: parent.enabled ? pal.normalBack1 : pal.window2
        border.color: pal.controlFrame
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            color: "transparent"
            border.color: pal.highlight
        }
    }

    Item {
        id: container
        anchors.fill: parent
        anchors.margins: 2
        clip: true
        visible: enabled
        z: 1

        property int lastPressedX: 0
        property int lastPressedY: 0

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            z: 1
            onPressed: {
                root.forceActiveFocus();
                hideToolTip();
                var pos = mapToItem(editBox, mouse.x, mouse.y);
                var x = (pos.x - editBox.centerX) / root.imageScale;
                var y = (pos.y - editBox.centerY) / root.imageScale;
                root.newCellX = Math.max(-boxWidth / 2, Math.min(x, boxWidth / 2));
                root.newCellY = Math.max(-boxHeight / 2, Math.min(y, boxHeight / 2));
                mouse.accepted = false;
            }
        }

        AnimationScreenBody {
            id: body
            anchors.centerIn: parent
            width: container.width / imageScale + 1
            height: container.height / imageScale
            scale: imageScale
            fillColor: pal.workArea
            projectUrl: DataManager.projectUrl
            positionType: root.positionType
        }

        Item {
            id: editBox

            anchors.centerIn: parent
            anchors.verticalCenterOffset: body.offsetY * root.imageScale

            width: root.boxWidth * root.imageScale
            height: root.boxHeight * root.imageScale
            visible: !playing

            property int centerX: width / 2
            property int centerY: height / 2

            Rectangle {
                anchors.fill: parent
                antialiasing: true
                border.width: 1
                border.color: "lime"
                opacity: 0.25
                color: "transparent"
                Rectangle {
                    color: "lime"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 1
                    opacity: 0.5
                }
                Rectangle {
                    color: "lime"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 1
                    opacity: 0.5
                }
            }

            Repeater {
                id: shadowCellFrameRepeater
                model: maxCells

                Rectangle {
                    property var cellData: emptyCell
                    property real cellScale: cellData[3] / 100
                    property real finalScale: root.imageScale * cellScale
                    property int dataX: cellData[1]
                    property int dataY: cellData[2]

                    visible: cellData[0] >= 0
                    x: Math.round(editBox.centerX + dataX * root.imageScale - width / 2)
                    y: Math.round(editBox.centerY + dataY * root.imageScale - height / 2)
                    width: Math.round(patternSize * finalScale)
                    height: Math.round(patternSize * finalScale)
                    rotation: cellData[4]
                    antialiasing: true

                    border.width: 1
                    border.color: "black"
                    opacity: 0.50
                    color: "transparent"

                    Text {
                        color: parent.border.color
                        text: (index + 1).toString()
                        font.pixelSize: 10
                        x: 2
                    }
                }
            }

            Repeater {
                id: cellFrameRepeater
                model: maxCells

                Rectangle {
                    property var cellData: emptyCell
                    property real cellScale: cellData[3] / 100
                    property real finalScale: root.imageScale * cellScale
                    property int dataX: cellData[1]
                    property int dataY: cellData[2]

                    visible: cellData[0] >= 0
                    x: Math.round(editBox.centerX + dataX * root.imageScale - width / 2)
                    y: Math.round(editBox.centerY + dataY * root.imageScale - height / 2)
                    width: Math.round(patternSize * finalScale)
                    height: Math.round(patternSize * finalScale)
                    rotation: cellData[4]
                    antialiasing: true

                    border.width: 1
                    border.color: "white"
                    opacity: currentCellIndex === index ? 1 : 0.2
                    color: "transparent"

                    Text {
                        color: parent.border.color
                        text: (index + 1).toString()
                        font.pixelSize: 10
                        x: 2
                    }

                    MouseAreaEx {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton

                        property int lastX
                        property int lastY
                        property var pressedPos

                        onPressed: {
                            if (mouse.modifiers & Qt.ShiftModifier) {
                                if (!cellThrough) {
                                    cellThrough = true;
                                    mouse.accepted = false;
                                    return;
                                }
                            }
                            var pos = mapToItem(root, mouse.x, mouse.y);
                            pressedPos = pos;
                            lastX = dataX;
                            lastY = dataY;
                            currentCellIndex = index;
                            cellDragging = true;
                            root.forceActiveFocus();
                            hintArea.hideToolTip();
                        }

                        onPositionChanged: {
                            var pos = mapToItem(root, mouse.x, mouse.y);
                            var deltaX = Math.round(pos.x - pressedPos.x);
                            var deltaY = Math.round(pos.y - pressedPos.y);
                            var x = lastX + deltaX / root.imageScale;
                            var y = lastY + deltaY / root.imageScale;
                            parent.moveTo(x, y);
                            hintArea.hideToolTip();
                        }

                        onReleased: {
                            var newX = cellData[1];
                            var newY = cellData[2];
                            if (newX !== lastX || newY !== lastY) {
                                cellData[1] = lastX;
                                cellData[2] = lastY;
                                root.push();
                                cellData[1] = newX;
                                cellData[2] = newY;
                                helper.setModified();
                            }
                            cellDragging = false;
                            cellThrough = false;
                        }

                        onDoubleClicked: {
                            root.edit();
                        }

                        onLongPressed: {
                            popupShower.start();
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton
                        onPressed: {
                            currentCellIndex = index;
                            menu.popup();
                        }
                    }

                    Timer {
                        id: popupShower
                        interval: 10
                        onTriggered: {
                            menu.popup();
                        }
                    }

                    function moveTo(x, y) {
                        x = Math.max(-boxWidth / 2, Math.min(x, boxWidth / 2));
                        y = Math.max(-boxHeight / 2, Math.min(y, boxHeight / 2));
                        cellData[1] = x;
                        cellData[2] = y;
                        updateCells();
                    }

                    function moveBy(x, y) {
                        var newX = dataX + x;
                        var newY = dataY + y;
                        if (x !== 0) {
                            newX = Math.round(newX / gridSize) * gridSize;
                        }
                        if (y !== 0) {
                            newY = Math.round(newY / gridSize) * gridSize;
                        }
                        moveTo(newX, newY);
                    }
                }
            }
        }

        Text {
            id: coordinatesText
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "white"
            visible: !playing

            function update() {
                var cell = getCurrentCell();
                if (cell) {
                    var x = cell[1];
                    var y = cell[2];
                    text = "(" + x + "," + y + ") ";
                } else {
                    text = "";
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !playing

        onPressed: {
            currentCellIndex = -1;
            if (mouse.button === Qt.RightButton) {
                menu.popup();
            }
        }

        onDoubleClicked: {
            menu.updateMenuItems();
            if (mouse.button === Qt.LeftButton && menu.createEnabled) {
                create();
            }
        }
    }

    StandardPopupMenu {
        id: menu
        owner: root
        enabled: !cellDragging && !playing

        clipboardFormat: root.clipboardFormat
        validItemSelected: root.currentCellIndex >= 0
        createEnabled: false
        undoEnabled: undoManager.canUndo
        redoEnabled: undoManager.canRedo

        useEdit: true
        useNew: true
        useCut: true
        useCopy: true
        usePaste: true
        useDelete: true
        useUndo: true
        useRedo: true
        onEditEdit: root.edit()
        onEditNew: root.create()
        onEditCopy: root.copy()
        onEditPaste: root.paste()
        onEditDelete: root.remove()
        onEditUndo: root.undo();
        onEditRedo: root.redo();

        MenuSeparator {
        }

        MenuItem {
            text: qsTr("To Upper")
            shortcut: root.activeFocus ? "Page Up" : ""
            onTriggered: toUpper()
        }

        MenuItem {
            text: qsTr("To Lower")
            shortcut: root.activeFocus ? "Page Down" : ""
            onTriggered: toLower()
        }

        onUpdateMenuItems: {
            createEnabled = checkFrameExists() && getNewCellIndex() < maxCells;
        }
    }

    UndoManager {
        id: undoManager
    }

    Timer {
        id: player
        interval: 1000/15
        repeat: true

        property int frameIndex: 0

        onTriggered: {
            frameIndex++;
            if (frameIndex >= root.maxFrames + 4) {
                stopPlayback();
            } else {
                updateCells();
                body.updateEffects();
                applyTimingData(frameIndex);
            }
        }
    }

    onObjectChanged: {
        currentCellIndex = -1;
        if (object) {
            updateImages();
            updateTargetImage();
            updateCells();
            stopPlayback();
            undoManager.clear();
        }
    }

    onFrameIndexChanged: {
        if (object) {
            updateCells();
            undoManager.clear();
        }
    }

    onActiveFocusChanged: {
        menu.updateMenuItems();
    }

    onCurrentCellIndexChanged: {
        coordinatesText.update();
    }

    Keys.onUpPressed: moveCurrentCell(0, -1)
    Keys.onLeftPressed: moveCurrentCell(-1, 0)
    Keys.onRightPressed: moveCurrentCell(1, 0)
    Keys.onDownPressed: moveCurrentCell(0, 1)

    function startPlayback() {
        player.frameIndex = -6;
        player.start();
    }

    function stopPlayback() {
        player.stop();
        body.clearEffects();
        updateCells();
    }

    function applyTimingData(frameIndex) {
        var timings = getTimingArray();
        for (var i = 0; i < timings.length; i++) {
            var timing = timings[i];
            if (timing.frame === frameIndex) {
                var r = timing.flashColor[0];
                var g = timing.flashColor[1];
                var b = timing.flashColor[2];
                var a = timing.flashColor[3];
                switch (timing.flashScope) {
                case 1: // Target
                    body.startTargetFlash(r, g, b, a, timing.flashDuration);
                    break;
                case 2: // Screen
                    body.startScreenFlash(r, g, b, a, timing.flashDuration);
                    break;
                case 3: // Hide Target
                    body.startTargetHiding(timing.flashDuration);
                    break;
                }
                if (timing.se && timing.se.name) {
                    AudioPlayer.play('se', timing.se);
                }
            }
        }
    }

    function hideToolTip() {
        hintArea.hideToolTip();
        hintArea.hideToolTipOnDelay();
    }

    function updateImages() {
        var image1Name = DataManager.getObjectValue(object, "animation1Name", "");
        var image1Hue = DataManager.getObjectValue(object, "animation1Hue", 0);
        var image2Name = DataManager.getObjectValue(object, "animation2Name", "");
        var image2Hue = DataManager.getObjectValue(object, "animation2Hue", 0);
        body.setImage1(image1Name, image1Hue);
        body.setImage2(image2Name, image2Hue);
    }

    function updateTargetImage() {
        var subFolder = DataManager.enemiesFolder;
        var targetImageName = DataManager.getSystemValue("battlerName", "");
        var targetImageHue = DataManager.getSystemValue("battlerHue", "");
        body.setTargetImage(subFolder, targetImageName, targetImageHue);
    }

    function updateCells() {
        var i, cellFrame, cellArray, data;

        cellArray = getCellArray();
        for (i = 0; i < maxCells; i++) {
            cellFrame = getCellFrame(i);
            if (i < cellArray.length) {
                cellFrame.cellData = cellArray[i];
            } else {
                cellFrame.cellData = emptyCell;
            }
        }
        data = Array.prototype.concat.apply([], cellArray);

        cellArray = getShadowCellArray();
        for (i = 0; i < maxCells; i++) {
            cellFrame = getShadowCellFrame(i);
            if (i < cellArray.length) {
                cellFrame.cellData = cellArray[i];
            } else {
                cellFrame.cellData = emptyCell;
            }
        }
        if (!playing) {
            var shadowData = Array.prototype.concat.apply([], cellArray);
            for (i = 0; i < maxCells; i++) {
                shadowData[i * 8 + 6 /* opacity */] *= 0.5;
            }
            data = data.concat(shadowData);
        }

        body.data = data;
        coordinatesText.update();
    }

    function getCellFrame(index) {
        return cellFrameRepeater.itemAt(index);
    }

    function getShadowCellFrame(index) {
        return shadowCellFrameRepeater.itemAt(index);
    }

    function getCellArray() {
        var frameArray = getFrameArray();
        var index = player.running ? player.frameIndex : root.frameIndex;
        return frameArray[index] || [];
    }

    function getShadowCellArray() {
        var frameArray = getFrameArray();
        var index = root.frameIndex - 1;
        return frameArray[index] || [];
    }

    function setCellArray(cellArray) {
        var frameArray = getFrameArray();
        var index = player.running ? player.frameIndex : root.frameIndex;
        frameArray[index] = cellArray;
        updateCells();
        helper.setModified();
    }

    function getFrameArray() {
        return DataManager.getObjectValue(object, "frames", []);
    }

    function getCurrentCell() {
        var cellArray = getCellArray();
        return cellArray[currentCellIndex];
    }

    function setCurrentCell(cellData) {
        var cellArray = getCellArray();
        cellArray[currentCellIndex] = cellData;
        updateCells();
        helper.setModified();
    }

    function getTimingArray() {
        return DataManager.getObjectValue(object, "timings", []);
    }

    function moveCurrentCell(x, y) {
        if (currentCellIndex >= 0) {
            var cellFrame = getCellFrame(currentCellIndex);
            push();
            cellFrame.moveBy(x * gridSize, y * gridSize);
        }
    }

    function edit() {
        editCell();
    }

    function finishEdit(cellData) {
        push();
        setCurrentCell(cellData);
    }

    function create() {
        var cellArray = getCellArray();
        var newIndex = getNewCellIndex();
        push();
        cellArray[newIndex] = [newPattern, newCellX, newCellY, 100, 0, 0, 255, OneMakerMVSettings.getSetting("animationScreenBlendMode", "default")];
        currentCellIndex = newIndex;
        updateCells();
        helper.setModified();
    }

    function copy() {
        var cellArray = getCellArray();
        var clipData = cellArray[currentCellIndex];
        if (clipData) {
            Clipboard.setData(clipboardFormat, JSON.stringify(clipData));
        } else {
            Clipboard.clear();
        }
    }

    function paste() {
        var clipData = JSON.parse(Clipboard.getData(clipboardFormat));
        if (clipData) {
            var cellArray = getCellArray();
            var newIndex = getNewCellIndex();
            push();
            clipData[1] = newCellX;
            clipData[2] = newCellY;
            cellArray[newIndex] = clipData;
            currentCellIndex = newIndex;
            updateCells();
            helper.setModified();
        }
    }

    function remove() {
        var cellArray = getCellArray();
        push();
        if (currentCellIndex < cellArray.length - 1) {
            cellArray[currentCellIndex][0] = -1;
        } else {
            cellArray.splice(currentCellIndex, 1);
        }
        updateCells();
        helper.setModified();
    }

    function toUpper() {
        var cellArray = getCellArray();
        var cell = getCurrentCell();
        var newCellIndex = currentCellIndex + 1;
        if (cell && newCellIndex < maxCells) {
            push();
            if (newCellIndex >= cellArray.length) {
                cellArray.push(DataManager.clone(emptyCell));
            }
            var temp = cellArray[newCellIndex];
            cellArray[newCellIndex] = cellArray[currentCellIndex];
            cellArray[currentCellIndex] = temp;
            currentCellIndex = newCellIndex;
            updateCells();
            helper.setModified();
        }
    }

    function toLower() {
        var cellArray = getCellArray();
        var cell = getCurrentCell();
        var newCellIndex = currentCellIndex - 1;
        if (cell && newCellIndex >= 0) {
            push();
            var temp = cellArray[newCellIndex];
            cellArray[newCellIndex] = cellArray[currentCellIndex];
            cellArray[currentCellIndex] = temp;
            currentCellIndex = newCellIndex;
            updateCells();
            helper.setModified();
        }
    }

    function push() {
        undoManager.push("cell", getCellArray());
    }

    function undo() {
        var item = undoManager.undo();
        if (item.type === "cell") {
            if (!undoManager.canRedo) {
                undoManager.pushToHead("cell", getCellArray());
            }
            setCellArray(item.data);
        }
    }

    function redo() {
        var item = undoManager.redo();
        if (item.type === "cell") {
            setCellArray(item.data);
        }
    }

    function checkFrameExists() {
        return getFrameArray().length > 0;
    }

    function getNewCellIndex() {
        var cellArray = getCellArray();
        for (var i = 0; i < cellArray.length; i++) {
            if (cellArray[i][0] < 0) {
                return i;
            }
        }
        return cellArray.length;
    }
}
