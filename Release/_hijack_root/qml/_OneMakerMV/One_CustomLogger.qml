pragma Singleton
import QtQuick 2.3
import Tkool.rpg 1.0
import "../Singletons"

QtObject {
    function initialize() {
        var path = TkoolAPI.pathToUrl(TkoolAPI.applicationDirPath()) + "/Console.log";
        TkoolAPI.writeFile(path, "");
    }

    function log(message) {
        var path = TkoolAPI.pathToUrl(TkoolAPI.applicationDirPath()) + "/Console.log";
        var data = TkoolAPI.readFile(path);
        if (data.length) {
            data += "\n" + message;
        } else {
            data = message;
        }
        
        TkoolAPI.writeFile(path, data)
    }
}