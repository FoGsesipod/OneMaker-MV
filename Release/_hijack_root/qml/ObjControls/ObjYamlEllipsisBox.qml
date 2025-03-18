import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Dialogs"
import "../Singletons"
import "../_OneMakerMV"

LabeledEllipsisBox {
    id: root

    property string memberForName: ""
    property string memberForIndex: ""
    property string memberForName2: ""
    property var object: dataObject

    property string subFolder: ""
    property string subFolder2: ""

    property string fileName: ""
    property string messageName: ""
    property string savedFileName: ""
    property string savedMessageName: ""

    readonly property string folder: DataManager.projectUrl + subFolder
    property string folder2: DataManager.projectUrl + subFolder2

    signal modified()

    text: fileName + (messageName ? " & " + messageName : "")

    DialogBoxHelper { id: helper }

    Dialog_YamlSelector {
        id: dialog
        folder: root.folder

        onOk: {
            root.fileName = fileName;
            root.messageName = messageName;
            root.savedFileName = savedFileName;
            root.savedMessageName = savedMessageName;
            helper.setModified();
            root.modified();
            Logger.log("root file: ", root.fileName)
        }

        onInit: {
            fileName = root.fileName;
            messageName = root.messageName;
        }
    }

    onClicked: {
        dialog.open();
    }
}
