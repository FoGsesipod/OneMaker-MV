import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Dialogs"

ObjImageBox {
    id: root

    subFolder: "faces"
    imageScale: 2/3
    fixedFrameWidth: 106
    fixedFrameHeight: 106
    fixedMaxColumns: 4
    itemWidth: 104
    itemHeight: 104

    framePosition: Qt.point(imageIndex % 4, Math.floor(imageIndex / 4))
    frameSize: Qt.size(106, 106)
}
