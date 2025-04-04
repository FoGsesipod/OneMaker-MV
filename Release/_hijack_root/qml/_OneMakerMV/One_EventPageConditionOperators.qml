//======================================================================================
// OneMaker MV's Event Page Condition Operators
//======================================================================================
/* Contains the array for event page condition operators, as rpg_objects.js has
 * different values for different operators compared to if conditions.
 *
 * Do Not Modify This.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.4

QtObject {
    // ≥, >, ==, <, ≤, ≠ 
    readonly property var eventConditionOperatorArray: [
        qsTr("\u2265"), qsTr(">"), qsTr("="),
        qsTr("<"), qsTr("\u2264"), qsTr("\u2260")
    ]
}