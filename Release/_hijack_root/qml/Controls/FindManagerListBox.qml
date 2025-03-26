import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"

ListBox {
    id: root

    property string member: ""
    property var object: dataObject
    property string clipboardFormat: member

    readonly property bool emptyItemSelected: isJustSelected(rowCount - 1)

    property FindManager findManager: null

    model: ListModel {
        id: listModel
    }

    function getDataArray() {
        var array = DataManager.getObjectValue(object, member, null);
        if (array) {
            return array;
        } else {
            DataManager.setObjectValue(object, member, []);
            return DataManager.getObjectValue(object, member, []);
        }
    }

    DialogBoxHelper { id: helper }

    contextMenu: FindManagerPopupMenu {
        owner: root
        findManager: root.findManager
    }
}
