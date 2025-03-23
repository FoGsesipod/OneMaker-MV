import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Dialogs"
import "../Singletons"

LabeledEllipsisBox {
    id: root

    property var object: dataObject

    property string subFolder: ""

    property string fileName: ""
    property string messageName: ""
    property string displayName: ""
    property string savedFileName: ""
    property string savedMessageName: ""

    readonly property string folder: DataManager.projectUrl + subFolder

    signal modified()

    text: displayName

    DialogBoxHelper { id: helper }

    Dialog_YamlSelector {
        id: dialog
        folder: root.folder

        onOk: {
            root.fileName = fileName;
            root.messageName = messageName;
            root.savedFileName = savedFileName;
            root.savedMessageName = savedMessageName;
            root.displayName = root.fileName + (root.messageName  ? "." + root.messageName : "")
            helper.setModified();
            root.modified();
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
