//======================================================================================
// OneMaker MV's Custom Logger
//======================================================================================
/* Setups a method to use a `console.log()` type command for debugging purposes. 
 *
 * Do Not Modify This.
*/
//======================================================================================
pragma Singleton
import QtQuick 2.4
import Tkool.rpg 1.0

QtObject {
    function initialize() {
        var path = TkoolAPI.pathToUrl(TkoolAPI.applicationDirPath());
        var oldData = TkoolAPI.readFile(path + "/Console.log");

        if (oldData) {
            TkoolAPI.writeFile(path + "/Console-old.log", oldData);
        };

        TkoolAPI.writeFile(path + "/Console.log", "");
    }

    function log(message, object) {
        var time = new Date()
        time = Qt.formatDateTime(time, "[hh:mm:ss]")
        var path = TkoolAPI.pathToUrl(TkoolAPI.applicationDirPath()) + "/Console.log";
        var data = TkoolAPI.readFile(path);
        var output = message;

        if (typeof message === "object") {
            output = JSON.stringify(message);
        }
        else if (object) {
            output = message + JSON.stringify(object);
        };
        
        if (data.length) {
            data += "\n" + time + " " + output;
        } else {
            data = time + " " + output;
        };
        
        TkoolAPI.writeFile(path, data);
    }
}