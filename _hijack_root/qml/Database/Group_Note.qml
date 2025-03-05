import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"

GroupBox {
    id: root

    title: Constants.noteTitle
    hint: Constants.noteHint

    property alias itemWidth: item.itemWidth
    property alias itemHeight: item.itemHeight

    ObjTextArea {
        id: item
        member: "note"
        labelVisible: false
        title: root.title
        hint: root.hint
        hintComponent: root.hintComponent
        itemWidth: 520
        itemHeight: 375
        maximumLineCount: 0

        contextMenu: TextEditPopupMenu {
            MenuSeparator { }
            MenuItem_PluginHelpEverywhere { }
        }
    }
}
