//======================================================================================
// OneMaker MV's Self Variable Array Name
//======================================================================================
/* Naming scheme to use for Self Variables
 * You can expand the list or change the words displayed however you want.
 *
 * Just note that self variables start at id 0.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3

QtObject {
    // Words
    readonly property var namingScheme: [
        "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
    ]

    // Numbers
    //readonly property var namingScheme: [
    //    0, 1, 2, 3, 4, 5, 6, 7, 8, 9
    //]
}