import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"

GroupBoxColumn {
    id: root

    property int eventCode: 0
    property var eventData: null
    property int troopId: 0

    signal init()
    signal load()
    signal save()
    signal ok()
    signal cancel()

    Component.onCompleted: init()
    onOk: dialogBox.ok()
    onCancel: dialogBox.cancel()

    function makeSimpleEventData() {
        // [OneMaker MV] - Gaslight Event Command Base to think extra commands are base commands (currently not used but might be useful in the future)
        if (eventCode > 999) {
            eventCode -= 1000
        }
        eventData = [ makeCommand(eventCode, 0, []) ];
    }

    function makeCommand(code, indent, parameters) {
        return { code: code, indent: indent, parameters: parameters };
    }

    function makeNullCommand(indent) {
        return makeCommand(0, indent, []);
    }

    function getTopIndent() {
        if (eventData && eventData[0]) {
            return eventData[0].indent;
        } else {
            return 0;
        }
    }
}
