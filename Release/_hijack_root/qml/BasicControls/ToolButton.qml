import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "." as Local
import "../Singletons"
import "../_OneMakerMV"

ToolButton {
    id: root

    property alias title: hintArea.title
    property alias hint: hintArea.hint
    property alias hintComponent: hintArea.hintComponent

    property bool hovered: hintArea.containsMouse

    HintArea {
        id: hintArea
    }

    activeFocusOnTab: false
    width: 24+16
    height: 24+16

    style: ButtonStyle {
        background: Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 3
            border.width: 1
            border.color: Local.PaletteSingleton.controlFrame
            visible: control.enabled  && (control.checked || control.pressed || control.hovered)
            clip: true

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: {
                        if (control.checked) {
                            return Local.PaletteSingleton.hotButton1;
                        } else if (control.pressed) {
                            return Local.PaletteSingleton.pressedButton1;
                        } else {
                            return Local.PaletteSingleton.hotButton1;
                        }
                    }
                }
                GradientStop {
                    position: 1.0
                    color: {
                        if (control.checked) {
                            return Local.PaletteSingleton.hotButton1;
                        } else if (control.pressed) {
                            return Local.PaletteSingleton.pressedButton2;
                        } else {
                            return Local.PaletteSingleton.hotButton2;
                        }
                    }
                }
            }
        }
        label: Item {
            Image {
                source: control.iconSource
                anchors.centerIn: parent
                sourceSize.width: ImagePack.selectedImagePackSize[0] // [OneMaker MV] - Scale images to imageSize values
                sourceSize.height: ImagePack.selectedImagePackSize[1] // [OneMaker MV] - Scale images to imageSize values
                opacity: control.enabled ? 1 : 0.5
            }
        }
    }

    onActionChanged: {
        title = action.text || title;
        hint = action.hint || hint;
        tooltip = "";
    }
}
