import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Dialogs"
import "../Singletons"

LabeledEllipsisBox {
    id: root

    property string member: ""
    property var object: dataObject

    property string seName: ""
    property bool allowNull: false

    DialogBoxHelper { id: helper }

    Dialog_AriesSEEffectSelector {
        id: dialog
        model: makeModel()

        onInit: {
            if (member) {
                var audio = DataManager.getObjectValue(root.object, member, {});
            }
            else {
                seName = root.seName;
            }
        }

        onOk: {
            var audio = {};
            audio.name = seName;
            audio.volume = 90;
            audio.pitch = 100;
            audio.pan = 0;
            DataManager.setObjectValue(root.object, member, audio);
            helper.setModified();
            updateText();
        }
    }
    
    onClicked: {
        dialog.open();
    }

    onObjectChanged: {
        updateText();
    }

    function makeModel() {
        var dataArray = DataManager.plugins;

        for (var i = 0; i < dataArray.length; i++) {
            if (dataArray[i].name === "Aries001_AnimationScreenEffects") {
                var parameters = dataArray[i].parameters;
                var model = [parameters["Shake SE"], parameters["Blur SE"], parameters["ZoomBlur SE"], parameters["Glow SE"], parameters["Wave SE"], parameters["Distort SE"]];

                return model;
            }
        }
    }

    function updateText() {
        var audio = DataManager.getObjectValue(object, member, null);
        text = audio ? audio.name : "";
    }
}