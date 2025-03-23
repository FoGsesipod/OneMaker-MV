import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"

ObjImageBox {
    id: root

    readonly property bool savedBool: OneMakerMVSettings.getSetting("workingMode", "expectedContext")

    subFolder: "faces"
    imageScale: 2/3
    fixedFrameWidth: savedBool ? 106 : 144 // [OneMaker MV] - Changed to account for Working Mode
    fixedFrameHeight: savedBool ? 106 : 144 // [OneMaker MV] - Changed to account for Working Mode
    fixedMaxColumns: 4
    itemWidth: 104
    itemHeight: 104

    framePosition: Qt.point(imageIndex % 4, Math.floor(imageIndex / 4))
    frameSize: Qt.size(savedBool ? 106 : 144, savedBool ? 106 : 144) // [OneMaker MV] - Changed to account for Working Mode
}
