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

    title: qsTr("Frames")
    hint: qsTr("Animation frames.")
    width: 760 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
    height: 401 + OneMakerMVSettings.getWindowSetting("alternativeHeightIncrease") // [OneMaker MV] - Window Increased

    property int positionType: 0
    property int maxFrames: frameList.maxFrames
    property int maxCells: 16

    property alias frameIndex: frameList.currentIndex
    property alias newPattern: palette.currentPatternNumber

    property var object: dataObject

    Column {
        spacing: 10

        Row {
            spacing: 10

            AnimationFrameList {
                id: frameList
                width: 100
                height: screen.height
            }
            AnimationScreen {
                id: screen
                title: qsTr("Frame View")
                hint: qsTr("Displays the contents of the selected frame. Double-click on the empty area to place a new cell. Drag a cell to move it. Right-click to open the popup menu.")
                width: 470 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                height: 272 + OneMakerMVSettings.getWindowSetting("alternativeHeightIncrease") // [OneMaker MV] - Window Increased
                maxFrames: root.maxFrames
                maxCells: root.maxCells
                positionType: root.positionType
                frameIndex: root.frameIndex
                newPattern: root.newPattern
                onEditCell: cellDialog.open()
            }
            Item {
                width: 150
                height: screen.height
                ControlsColumn {
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    Button {
                        text: qsTr("Change Target") + "..."
                        hint: qsTr("Changes the image currently displayed for editing.")
                        width: parent.width
                        onClicked: targetSelector.open()
                    }
                    Item {
                        width: 1
                        height: 12
                    }
                    Button {
                        id: pasteLastButton
                        text: qsTr("Paste Last")
                        hint: qsTr("Makes the currently selected frame identical to the previous frame.")
                        width: parent.width
                        onClicked: root.pasteLast()
                    }
                    Button {
                        id: tweenButton
                        text: qsTr("Tween") + "..."
                        hint: qsTr("Automatically tweens the frames between the two specified frames.")
                        width: parent.width
                        onClicked: tweenDialog.open()
                    }
                    Button {
                        id: batchButton
                        text: qsTr("Batch") + "..."
                        hint: qsTr("Changes the properties for multiple cells in the specified frames.")
                        width: parent.width
                        onClicked: batchDialog.open()
                    }
                    Button {
                        id: shiftButton
                        text: qsTr("Shift") + "..."
                        hint: qsTr("Shifts the positions of multiple cells in the specified frames.")
                        width: parent.width
                        onClicked: shiftDialog.open()
                    }
                    Item {
                        width: 1
                        height: 12
                    }
                    Button {
                        text: qsTr("Play")
                        hint: qsTr("Tests the animation.")
                        width: parent.width
                        onClicked: screen.startPlayback()
                    }
                }
            }
        }
        AnimationPalette {
            id: palette
            title: qsTr("Pattern Palette")
            hint: qsTr("Select the pattern for a new cell.")
            width: 740 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
            height: 82
        }
    }

    DialogBoxHelper { id: helper }

    Dialog_ImageSelector {
        id: targetSelector
        folder: DataManager.projectUrl + "img/" + DataManager.enemiesFolder
        hueVisible: true

        onInit: {
            imageName = DataManager.getSystemValue("battlerName", "");
            imageHue = DataManager.getSystemValue("battlerHue", "");
        }

        onOk: {
            DataManager.setSystemValue("battlerName", imageName);
            DataManager.setSystemValue("battlerHue", imageHue);
            screen.updateTargetImage();
            helper.setModified();
        }
    }

    Dialog_AnimationCell {
        id: cellDialog
        locator: screen

        onInit: {
            dataObject = DataManager.clone(screen.getCurrentCell());
        }
        onOk: {
            screen.finishEdit(dataObject);
        }
        onClose: {
            screen.hideToolTip();
        }
    }

    Dialog_AnimationTween {
        id: tweenDialog
        locator: tweenButton
        maxFrames: root.maxFrames
        maxCells: root.maxCells
        dataObject: root.object

        onOk: {
            screen.updateCells();
            helper.setModified();
        }
    }

    Dialog_AnimationBatch {
        id: batchDialog
        locator: batchButton
        maxFrames: root.maxFrames
        maxCells: root.maxCells
        dataObject: root.object

        onOk: {
            screen.updateCells();
            helper.setModified();
        }
    }

    Dialog_AnimationShift {
        id: shiftDialog
        locator: shiftButton
        maxFrames: root.maxFrames
        maxCells: root.maxCells
        dataObject: root.object

        onOk: {
            screen.updateCells();
            helper.setModified();
        }
    }

    function pasteLast() {
        if (frameIndex > 0) {
            var frameArray = DataManager.getObjectValue(dataObject, "frames", []);
            frameArray[frameIndex] = DataManager.clone(frameArray[frameIndex - 1]);
        }
        screen.updateCells();
        helper.setModified();
    }

    function updateImages() {
        screen.updateImages();
        palette.updateImages();
    }

    function changeMaximum(n) {
        frameList.changeMaximum(n);
        screen.updateCells();
    }
}
