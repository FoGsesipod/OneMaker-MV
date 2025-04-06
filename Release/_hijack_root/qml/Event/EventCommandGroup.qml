import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"
import "../_OneMakerMV"

GroupBox {
    id: root

    property var codeList: []

    signal triggered(var code)

    Column {
        Repeater {
            model: codeList.length
            GroupButton {
                property int eventCode: codeList[index]
                enabled: OneMakerMVSettings.enableEventCommands(eventCode); // [OneMaker MV] - Detect if Button should be disabled or not.

                width: 220
                height: 25

                onEventCodeChanged: {
                    text = EventCommands.buttonText(eventCode);
                    hint = EventCommands.hint(eventCode);
                }

                onClicked: root.triggered(eventCode);
            }
        }
    }
}
