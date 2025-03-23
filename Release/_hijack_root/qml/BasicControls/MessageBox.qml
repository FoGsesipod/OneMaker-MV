import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import "../Singletons"
import "."
import "../_OneMakerMV"

ModalWindow {
    id: root;
    title: Constants.applicationTitle

    property string message
    property string iconType

    property bool useYesNo: false
    property bool useCancel: false

    Rectangle {
        id: rect
        width: column.width
        height: column.height

        property Window owner: null
        property int offsetX: 0
        property int offsetY: 0

        signal yes()
        signal no()
        signal ok()
        signal cancel()

        Action {
            id: yesAction
            enabled: root.useYesNo
            shortcut: "Y"
            onTriggered: {
                root.yes();
                close();
            }
        }
        Action {
            id: noAction
            enabled: root.useYesNo
            shortcut: "N"
            onTriggered: {
                root.no();
                close();
            }
        }
        Action {
            id: okAction
            enabled: !root.useYesNo
            onTriggered: {
                root.ok();
                close();
            }
        }
        Action {
            id: cancelAction
            enabled: !root.useYesNo || root.useCancel
            shortcut: "Esc"
            onTriggered: {
                root.cancel();
                close();
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: PaletteSingleton.window1 }
            GradientStop { position: 1.0; color: PaletteSingleton.window2 }
        }

        Column {
            id: column

            Rectangle {
                width: Math.max(band.width, implicitWidth)
                color: PaletteSingleton.normalBack1
                implicitWidth: Math.max(150, contents2.implicitWidth + 24)
                implicitHeight: Math.max(icon.height + 24, contents2.implicitHeight + 20)
                Row {
                    id: contents2
                    anchors.centerIn: parent
                    spacing: 12
                    Image {
                        id: icon
                        anchors.topMargin: 12
                        source: ImagePack.selectedImagePack + "%1.png".arg(iconType) // [OneMaker MV] - Obtain Image Pack
                        sourceSize.width: ImagePack.selectedImagePackSize[0] // [OneMaker MV] - Obtain Image Sizes
                        sourceSize.height: ImagePack.selectedImagePackSize[1] // [OneMaker MV] - Obtain Image Sizes
                        visible: source !== ""
                    }
                    Text {
                        id: messageText
                        text: root.message
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                        width: Math.min(400, sizeHint.paintedWidth)
                    }
                    Text {
                        id: sizeHint
                        text: root.message
                        wrapMode: Text.WordWrap
                        width: 400
                        visible: false
                    }
                }
            }
            Item {
                id: band
                anchors.right: parent.right
                implicitWidth: row.implicitWidth + 20 + 28
                implicitHeight: row.implicitHeight + 24
                Row {
                    id: row
                    spacing: 8
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10

                    function myChild(item) {
                        for (var i = 0; i < children.length; i++) {
                            if (item === children[i])
                                return item;
                        }
                        return null;
                    }

                    Button {
                        id: yesButton
                        action: yesAction
                        visible: root.useYesNo
                        text: qsTr("Yes", "Dialog Button")
                        KeyNavigation.left: visible ? row.myChild(nextItemInFocusChain(false)) : null
                        KeyNavigation.right: visible ? row.myChild(nextItemInFocusChain(true)) : null
                    }

                    Button {
                        id: noButton
                        action: noAction
                        visible: root.useYesNo
                        text: qsTr("No", "Dialog Button")
                        KeyNavigation.left: visible ? row.myChild(nextItemInFocusChain(false)) : null
                        KeyNavigation.right: visible ? row.myChild(nextItemInFocusChain(true)) : null
                    }

                    Button {
                        id: okButton
                        action: okAction
                        visible: !root.useYesNo
                        text: qsTr("OK", "Dialog Button")
                        KeyNavigation.left: visible ? row.myChild(nextItemInFocusChain(false)) : null
                        KeyNavigation.right: visible ? row.myChild(nextItemInFocusChain(true)) : null
                    }

                    Button {
                        id: cancelButton
                        action: cancelAction
                        visible: root.useCancel
                        text: qsTr("Cancel", "Dialog Button")
                        KeyNavigation.left: visible ? row.myChild(nextItemInFocusChain(false)) : null
                        KeyNavigation.right: visible ? row.myChild(nextItemInFocusChain(true)) : null
                    }
                }
            }
        }
    }
}
