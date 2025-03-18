//======================================================================================
// OneMaker MV's Image Pack
//======================================================================================
/* Changes the images that the editor uses.
 * Edit userSelection to modify what source the editor grabs images from.
 *
 * The list of acceptable value (Case Sensitive!):
 * - "Default"
 * - "MZ"
 * - "Koffin"
 * - "Krypt"
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3

QtObject {
    readonly property string userSelection: "MZ"
}