import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Comment
EventCommandBase {
    id: root

    property int eventCode1: 108
    property int eventCode2: 408

    TextArea {
        id: textArea
        title: qsTr("Comment")
        hint: qsTr("Comment text. Has no effect in the game.")
        width: 600 // Increased by 200
        height: fittingHeight(maximumLineCount)
        selectAllOnFocus: false
        maximumLineCount: 24 // Increased by 18

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
