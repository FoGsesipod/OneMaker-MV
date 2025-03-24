//======================================================================================
// OneMaker MV's Image Pack
//======================================================================================
/* Handles the image folder location, dependent on whichever Image Pack is selected
 *
 * Do Not Modify This.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.4
import "../Singletons"

QtObject {
    property string selectedImagePack: ""
    property var selectedImagePackSize: []

    Component.onCompleted: {
        obtainImagePack()
        obtainImageSizes()
    }

    function obtainImagePack() {
        switch (OneMakerMVSettings.getSetting("imagePack", "userSelection")) {
            case "Default":
                selectedImagePack = "../Images/";
                break;
            case "MZ":
                selectedImagePack = "../Images/MZ/";
                break;
            case "Koffin":
                selectedImagePack = "../Images/Koffin/";
                break;
            case "Krypt":
                selectedImagePack = "../Images/Krypt/";
                break;
            default:
                selectedImagePack = "../Images/";
                break;
        }
    }

    function obtainImageSizes() {
        switch (OneMakerMVSettings.getSetting("imagePack", "userSelection")) {
            case "Default":
                selectedImagePackSize = [40, 40];
                break;
            case "MZ":
                selectedImagePackSize = [38, 38];
                break;
            case "Koffin":
                selectedImagePackSize = [40, 40];
                break;
            case "Krypt":
                selectedImagePackSize = [40, 40];
                break;
            default:
                selectedImagePackSize = [40, 40];
                break;
        }
    }
}