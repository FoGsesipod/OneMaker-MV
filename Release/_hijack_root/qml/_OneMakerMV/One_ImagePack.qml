//======================================================================================
// OneMaker MV's Image Pack
//======================================================================================
/* Handles the image folder location, dependent on userSelection in 
 * One_UserImageSelection.qml
 *
 * Do Not Modify This.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.3
import "../Singletons"

QtObject {
    property string imagePack: ""
    property var imageSize: []

    function obtainImagePack() {
        switch (UserImageSelection.userSelection) {
            case "Default":
                imagePack = "../Images/";
                break;
            case "MZ":
                imagePack = "../Images/MZ/";
                break;
            case "Koffin":
                imagePack = "../Images/Koffin/";
                break;
            case "Krypt":
                imagePack = "../Images/Krypt/";
                break;
            default:
                imagePack = "../Images/";
                break;
        }

        return imagePack;
    }

    function obtainImageSizes() {
        switch (UserImageSelection.userSelection) {
            case "Default":
                imageSize = [40, 40];
                break;
            case "MZ":
                imageSize = [38, 38];
                break;
            case "Koffin":
                imageSize = [40, 40];
                break;
            case "Krypt":
                imageSize = [40, 40];
                break;
            default:
                imageSize = [40, 40];
                break;
        }

        return imageSize;
    }
}