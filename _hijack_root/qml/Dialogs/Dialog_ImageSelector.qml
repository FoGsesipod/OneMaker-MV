import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Select an Image")

    property string imageName: ""
    property int imageIndex: 0
    property int imageHue: 0
    property string imageName2: ""

    property string folder: ""
    property string folder2: ""
    property real imageScale: 1.0
    property bool imageDual: false
    property bool imageFixed: false

    property int horizontalDivision: 1
    property int verticalDivision: 1
    property int bigHorizontalDivision: 1
    property int bigVerticalDivision: 1
    property int fixedFrameWidth: 0
    property int fixedFrameHeight: 0
    property int fixedMaxColumns: 0

    property bool useBigImagePrefix: false
    property int viewWidth: imageDual ? 376 : 496
    property bool showIndexText: false
    property bool hueVisible: false
    property var additionalItems: null

    property string indexTextTitle: ""
    property string indexTextHint: ""

    property int frameX: 0
    property int frameY: 0

    DialogBox {
        applyVisible: false

        onOk: {
            if (listBox1.visible && listBox1.currentItem) {
                if (listBox1.currentIndex === 0) {
                    root.imageName = "";
                } else {
                    root.imageName = listBox1.currentItem.fileBaseName;
                }
            }
            if (listBox2.visible && listBox2.currentItem) {
                if (listBox2.currentIndex === 0) {
                    root.imageName2 = "";
                } else {
                    root.imageName2 = listBox2.currentItem.fileBaseName;
                }
            }
        }

        DialogBoxRow {
            FileListBox {
                id: listBox1

                width: 200 + Constants.windowDefaultWidthIncrease // Window Increased
                height: 402 + Constants.windowDefaultHeightIncrease // Window Increased
                visible: !imageFixed

                folder: imageFixed ? "" : root.folder
                allowedSuffixes: ["png"]

                additionalItems: root.additionalItems

                onCurrentBaseNameChanged: {
                    if (currentItem) {
                        root.imageName = currentItem.fileBaseName;
                    }
                }
                onUpdated: {
                    selectName(root.imageName);
                }
                onDoubleClicked: {
                    ok();
                    TutorialManager.onDoubleClickedMenu("listBox1", this);
                }
                onClicked: TutorialManager.onClickedMenu("listBox1", this);
            }

            FileListBox {
                id: listBox2

                width: listBox1.width
                height: listBox1.height
                visible: !imageFixed && imageDual

                folder: imageFixed ? "" : root.folder2
                allowedSuffixes: listBox1.allowedSuffixes

                onCurrentBaseNameChanged: {
                    if (currentItem) {
                        root.imageName2 = currentItem.fileBaseName;
                    }
                }
                onUpdated: {
                    selectName(root.imageName2);
                }
                onDoubleClicked: {
                    ok();
                    TutorialManager.onDoubleClickedMenu("listBox2", this);
                }
                onClicked: TutorialManager.onClickedMenu("listBox2", this);
            }

            ColumnLayout {
                width: root.viewWidth + Constants.windowDefaultWidthIncrease // Window Increased (Originally was + 2)
                height: listBox1.height
                spacing: 10

                ImageSelectorView {
                    id: view
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    source: imageFixed ? root.folder + "/" + root.imageName : listBox1.currentPath
                    source2: imageFixed ? "" : listBox2.currentPath
                    horizontalDivision: root.horizontalDivision
                    verticalDivision: root.verticalDivision
                    bigHorizontalDivision: root.bigHorizontalDivision
                    bigVerticalDivision: root.bigVerticalDivision
                    fixedFrameWidth: listBox1.currentFrameWidth || root.fixedFrameWidth
                    fixedFrameHeight: listBox1.currentFrameWidth || root.fixedFrameHeight
                    fixedMaxColumns: listBox1.currentMaxColumns || root.fixedMaxColumns
                    isBigImage: useBigImagePrefix && DataManager.isBigCharacter(listBox1.currentName)
                    imageIndex: root.imageIndex
                    imageHue: hueSlider.value
                    imageScale: listBox1.currentScale || root.imageScale

                    onImageIndexChanged: root.imageIndex = imageIndex
                    onFrameXChanged: root.frameX = frameX
                    onFrameYChanged: root.frameY = frameY
                }

                GroupBox {
                    id: hueGroup
                    title: qsTr("Hue")
                    hint: qsTr("Adjusts the hue offset for the image.")
                    Layout.fillWidth: true
                    visible: root.hueVisible

                    SliderSpinBox {
                        id: hueSlider
                        title: hueGroup.title
                        hint: hueGroup.hint
                        labelVisible: false
                        itemWidth: hueGroup.width - 110
                        minimumValue: 0
                        maximumValue: 360
                        tickSpan: 36
                        value: root.imageHue

                        onValueChanged: root.imageHue = value
                    }
                }
            }
        }

        DialogBoxAddon {
            Label {
                title: root.indexTextTitle
                hint: root.indexTextHint

                opacity: 0.5
                visible: root.showIndexText
                text: root.imageIndex
            }
        }
    }
}
