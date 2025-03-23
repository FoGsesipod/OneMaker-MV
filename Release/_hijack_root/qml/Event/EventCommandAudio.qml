import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Layouts"

EventCommandBase {
    id: root

    property string subFolder: ""
    property alias audioName: audioSelector.audioName
    property alias volume: audioSelector.volume
    property alias pitch: audioSelector.pitch
    property alias pan: audioSelector.pan

    Layout_AudioSelector {
        id: audioSelector
        subFolder: root.subFolder
    }

    // [OneMaker MV] - Add Fade In for Bgm
    //LabeledSpinBox {
    //    id: spinBox
    //    title: qsTr("Fade In duration in seconds")
    //    hint: qsTr("")
    //    minimumValue: 0
    //    maximumValue: 120
    //    value: 0
    //    visible: subFolder === "bgm"
    //}

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            var audio = params[0];
            root.audioName = audio.name;
            root.volume = audio.volume;
            root.pitch = audio.pitch;
            root.pan = audio.pan || 0;
        }
    }

    onSave: {
        if (!eventData) {
            makeSimpleEventData();
        }
        var params = eventData[0].parameters;
        var audio = {};
        audio.name = root.audioName;
        audio.volume = root.volume;
        audio.pitch = root.pitch;
        audio.pan = root.pan;
        params[0] = audio;

        // [OneMaker MV] - Add a script command for fading in Bgm.
        if (spinBox.value > 0) {
            eventData.push( makeCommand(355, 0, []) );
            params = eventData[1].parameters;
            var scriptCommandText = "AudioManager.fadeInBgm(" + spinBox.value + ")";
            params[0] = scriptCommandText;
        }
    }
}
