//======================================================================================
// OneMaker MV's Image Pack
//======================================================================================
/* Changes the images that the editor uses.
 * Edit userSelection to modify what source the editor grabs images from.
 *
 * The list of acceptable value (Case Sensitive!):
 * - "Default"
 * - "MZ"
 * - "Saffron"
 * - "Koffin"
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3

QtObject {
    readonly property string userSelection: "Koffin"

    property string imagePack
    property var imageSize

    function obtainImagePack() {
        switch (userSelection) {
            case "Default":
                imagePack = "../Images/";
                break;
            case "MZ":
                imagePack = "../Images/MZ/";
                break;
            case "Saffron":
                imagePack = "../Images/Saffron/";
                break;
            case "Koffin":
                imagePack = "../Images/Koffin/";
                break;
            default:
                imagePack = "../Images/";
                break;
        }

        return imagePack;
    }

    function obtainImageSizes() {
        switch (userSelection) {
            case "Default":
                imageSize = [40, 40];
                break;
            case "MZ":
                imageSize = [38, 38];
                break;
            case "Saffron":
                imageSize = [0, 0];
                break;
            case "Koffin":
                imageSize = [40, 40];
                break;
            default:
                imageSize = [40, 40];
                break;
        }

        return imageSize;
    }
}