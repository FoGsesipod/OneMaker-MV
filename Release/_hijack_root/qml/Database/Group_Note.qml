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
        itemWidth: 320 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultWidthIncrease") // [OneMaker MV] - Window Increased
        itemHeight: 175 + OneMakerMVSettings.getWindowSetting("windowSizes", "defaultHeightIncrease") // [OneMaker MV] - Window Increased
        maximumLineCount: 0
        selectAllOnFocus: false // [OneMaker MV] - Changed to false

        contextMenu: TextEditPopupMenu {
            MenuSeparator { }
            MenuItem_PluginHelpEverywhere { }
        }
    }
}
