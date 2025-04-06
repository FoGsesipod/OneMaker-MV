import QtQuick 2.3
import QtQuick.Controls 1.2
import "../Dialogs"
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"
import "../_OneMakerMV"

LabeledComboBox {
    id: root

    property string member: ""
    property var object: dataObject

    readonly property string currentCharacter: model[currentIndex]

    model: OneMakerMVSettings.getSetting("selfSwitchNaming", "namingScheme") // [OneMaker MV] - Changed to include E - Z

    itemWidth: 90

    signal modified()

    DialogBoxHelper { id: helper }

    onObjectChanged: {
        if (member.length) {
            setCharacter(DataManager.getObjectValue(object, member, 0));
        }
    }

    onCurrentIndexChanged: {
        var character = model[currentIndex];
        if (member.length && DataManager.setObjectValue(object, member, character)) {
            helper.setModified();
            modified();
        }
    }

    function setCharacter(character) {
        for (var i = 0; i < model.length; i++) {
            if (model[i] === character) {
                currentIndex = i;
                break;
            }
        }
    }
}
