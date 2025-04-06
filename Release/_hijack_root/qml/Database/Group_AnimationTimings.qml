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

    property string member: "timings"

    title: qsTr("SE and Flash Timing")
    hint: qsTr("SE and flash colors, etc. used when a frame is displayed.")

    property alias itemWidth: listBox.width
    property alias itemHeight: listBox.height
    property int maxFrames: 1

    Dialog_AnimationTimings {
        id: dialog
        locator: root
        maxFrames: root.maxFrames

        function setDataObject(data) {
            if (data) {
                dataObject = DataManager.clone(data);
            } else {
                dataObject = {
                    frame: 0,
                    se: null,
                    flashScope: 0,
                    flashColor: [255,255,255,255],
                    flashDuration: 5
                };
            }
        }

        onOk: {
            listBox.finishEdit(dataObject);
        }
    }

    Row {
        SmartListBox {
            id: listBox
            member: root.member
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent
            width: 520 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
            height: 177 + OneMakerMVSettings.getWindowSetting("alternativeHeightIncrease") // [OneMaker MV] - Window Increased
            dragDrop: true

            ListBoxColumn {
                title: qsTr("No.", "Frame Number")
                role: "frame"
                width: 70
            }
            ListBoxColumn {
                title: qsTr("SE")
                role: "se"
                width: 150 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
            }
            ListBoxColumn {
                title: qsTr("Flash")
                role: "flash"
                width: OneMakerMVSettings.getWindowSetting("groupAnimationTimingsListBoxWidth") // [OneMaker MV] - Width was changed to use Window Sizes constant since 282 + Constant wasn't working
            }

            function editItem(data) {
                dialog.setDataObject(data);
                dialog.open();
            }

            function makeModelItem(data) {
                var item = {};
                if (data) {
                    item.frame = "#" + ("000" + ((data.frame || 0) + 1)).slice(-3);
                    item.se = data.se ? data.se.name : "";
                    switch (data.flashScope) {
                    case 1:
                        item.flash = qsTr("Target");
                        break;
                    case 2:
                        item.flash = qsTr("Screen");
                        break;
                    case 3:
                        item.flash = qsTr("Hide Target");
                        break;
                    default:
                        item.flash = "";
                        break;
                    }
                    if (data.flashScope >= 1 && data.flashScope <= 2) {
                        var c = data.flashColor;
                        item.flash += "(%1,%2,%3,%4)".arg(c[0]).arg(c[1]).arg(c[2]).arg(c[3]);
                    }
                    if (data.flashScope >= 1 && data.flashScope <= 3) {
                        var duration = data.flashDuration;
                        item.flash += ", ";
                        item.flash += Constants.framesText(duration);
                    }
                } else {
                    item.frame = "";
                    item.se = "";
                    item.flash = "";
                }
                return item;
            }
        }
    }
}
