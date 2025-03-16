//======================================================================================
// OneMaker MV's Max Level
//======================================================================================
/* Modifies the maximun level available for Actors, Classes, and the Change Level
 * Event Command. 
 * Set maximun to whatever you desire.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.4

QtObject {
    readonly property var maximun: 99
}