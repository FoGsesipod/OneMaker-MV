import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Singletons"

DialogBoxRow {
    id: root

    property string subFolder: ""
    property string audioName: ""
    property int volume: 90
    property int pitch: 100
    property int pan: 0

    property string playingAudioName: "";
    property bool restoreLast: false;
    property bool previewable: ["se", "me", "bgm", "bgs"].indexOf(subFolder) !== -1
    property bool parameterVisible: true

    FileListBox {
        id: listBox

        width: 200
        height: 402

        allowedSuffixes: ["ogg"]  // and m4a
        folder: DataManager.projectUrl + "audio/" + subFolder

        onCurrentBaseNameChanged: root.updateAudioName()
        onDoubleClicked: root.play()
        onUpdated: selectName(root.audioName)
    }

    GroupBoxColumn {
        ControlsColumn {
            visible: previewable
            Button {
                id: playButton
                width: 120
                text: qsTr("Play")
                hint: qsTr("Plays the selected file.")
                onClicked: root.play()
            }
            Button {
                width: playButton.width
                text: qsTr("Stop")
                hint: qsTr("Stops the current playback.")
                onClicked: root.stop()
            }
        }
        Layout_AudioParameter {
            id: volumeGroup
            width: playButton.width
            title: qsTr("Volume")
            hint: qsTr("Volume for audio playback.")
            minimumValue: 0
            maximumValue: 100
            stepSize: 5
            suffix: " %"
            value: root.volume
            onChanged: root.changeVolume()
            visible: parameterVisible
        }
        Layout_AudioParameter {
            id: pitchGroup
            width: volumeGroup.width
            title: qsTr("Pitch")
            hint: qsTr("Pitch for audio playback.")
            minimumValue: 10 // [OneMaker MV] - Decreased Minimun
            maximumValue: 200 // [OneMaker MV] - Increased Maximun
            stepSize: 10
            suffix: " %"
            value: root.pitch
            onChanged: root.changePitch()
            visible: parameterVisible
        }
        Layout_AudioParameter {
            id: panGroup
            width: volumeGroup.width
            title: qsTr("Pan")
            hint: qsTr("Pan for audio playback.")
            minimumValue: -100
            maximumValue: 100
            stepSize: 20
            tickSpan: 20
            value: root.pan
            onChanged: root.changePan()
            visible: parameterVisible
        }
    }

    function play() {
        var audio = {
            name: audioName,
            volume: volume,
            pitch: pitch,
            pan: pan
        };
        if (subFolder === 'se') {
            AudioPlayer.stop(subFolder);
        }
        AudioPlayer.play(subFolder, audio);
        playingAudioName = audioName;
    }

    function stop() {
        AudioPlayer.stop(subFolder);
        playingAudioName = "";
    }

    function changeVolume() {
        volume = volumeGroup.value;
        changePlayingAudio();
    }

    function changePitch() {
        pitch = pitchGroup.value;
        changePlayingAudio();
    }

    function changePan() {
        pan = panGroup.value;
        changePlayingAudio();
    }

    function updateAudioName() {
        root.audioName = listBox.currentBaseName;
    }

    function changePlayingAudio() {
        if (playingAudioName === audioName) {
            play();
        }
    }

    Component.onCompleted: {
        var audio = AudioPlayer.getLastPlayed(subFolder);
        if (audio && restoreLast) {
            audioName = audio.name;
            volume = audio.volume;
            pitch = audio.pitch;
            pan = audio.pan;
        }
    }
}
