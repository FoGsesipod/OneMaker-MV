import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Script
EventCommandBase {
    id: root

    property int eventCode1: 355
    property int eventCode2: 655

    TextArea {
        id: textArea
        title: qsTr("Script")
        hint: qsTr("JavaScript code to be evaluated.")
        width: 400 + Constants.windowDefaultWidthIncrease // Window Increased
        height: fittingHeight(maximumLineCount)
        selectAllOnFocus: false
        maximumLineCount: 36 // Increased by 24

        onKeyPressed: {
            if (event.key === Qt.Key_Return && isFinalLine()) {
                root.ok();
            }
        }

        function isFinalLine() {
            return currentLineIndex === maximumLineCount - 1;
        }

        contextMenu: TextEditPopupMenu {
            MenuSeparator { }
            MenuItem_PluginHelpEverywhere { }
            MenuItem_IconSetViewer { }
        }
    }

    onLoad: {
        if (eventData) {
            var lines = [];
            for (var i = 0; i < eventData.length; i++) {
                var command = eventData[i];
                if (command.code === (i === 0 ? eventCode1 : eventCode2)) {
                    lines.push(command.parameters[0]);
                } else {
                    break;
                }
            }
            textArea.text = lines.join("\n");
            textArea.cursorPosition = textArea.text.length;
        }
    }

    onSave: {
        eventData = [];
        var lines = textArea.text.split("\n");
        while (lines.length > 1 && lines[lines.length - 1].length === 0) {
            lines.pop();
        }
        for (var i = 0; i < lines.length; i++) {
            var code = (i === 0 ? eventCode1 : eventCode2);
            eventData.push(makeCommand(code, 0, [lines[i]]));
        }
    }
}
