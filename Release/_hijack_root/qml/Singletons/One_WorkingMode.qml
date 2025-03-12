//======================================================================================
// OneMaker MV's Working Mode
//======================================================================================
/* This file is used to globally enable or disable features that might prevent
 * usage of OneMaker MV for projects other then OMORI.
 * 
 * By default this project will assume the user is modding OMORI, therefore the OMORI
 * specific changes will automatically be enabled.
 *
 * A list of features that are changed that may harm functionality for projects other 
 * than OMORI:
 * - Show Text portrait size is reduced to 106x106, instead of 144x144.
 * - Actions Patterns is completely removed from Enemies in the database.
 *
 * To disable these changes, set `workingMode` to false.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3

QtObject {
    readonly property bool expectedContext: true
}