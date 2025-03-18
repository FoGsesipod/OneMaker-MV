//======================================================================================
// OneMaker MV's Yaml Identifiers
//======================================================================================
/* The array used for skipping Yaml Message Identifiers, generally you shouldn't need
 * to modify this unless you are developing a yaml related plugin.
 *
 * If you are, you can fix OneMaker's Yaml Selector by adding your indentifer to
 * ignoreIdentifiers
 *
 * You can also create an issue on the github (or contact FoGsesipod via discord dm)
 * and I will update this list publicly.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.4

QtObject {
    readonly property var ignoreIdentifiers: [
        "#", "faceset", "faceindex", "extrafaces", "windowskin", "bust", "okegomrapefetish"
    ]
}