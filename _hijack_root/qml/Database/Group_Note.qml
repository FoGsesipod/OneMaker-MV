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
        itemWidth: 320 + WindowSizes.defaultWidthIncrease // [OneMaker MV] - Window Increased
        itemHeight: 175 + WindowSizes.defaultHeightIncrease // [OneMaker MV] - Window Increased
        maximumLineCount: 0
        selectAllOnFocus: SelectAllOnFocus.database // [OneMaker MV] - Changed to use users settings

        contextMenu: TextEditPopupMenu {
            MenuSeparator { }
            MenuItem_PluginHelpEverywhere { }
        }
    }
}
