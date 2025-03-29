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
    property bool expandHeight: subFolder === "bgm" || subFolder === "bgs"

    property string audioName: ""
    property int volume: 90
    property int pitch: 100
    property int pan: 0
    property bool stopSound: checkBox.checked
    property bool disable: false
    property bool disableStopSound: false

    property string playingAudioName: "";
    property bool restoreLast: false;
    property bool previewable: ["se", "me", "bgm", "bgs"].indexOf(subFolder) !== -1
    property bool parameterVisible: true

    property bool fadeable: false

    signal modified()

    FileListBox {
        id: listBox

        width: 200
        height: expandHeight ? 402 : 522

        allowedSuffixes: ["ogg"]  // and m4a
        folder: DataManager.projectUrl + "audio/" + subFolder

        onCurrentBaseNameChanged: root.updateAudioName()
        onDoubleClicked: root.play()
        onUpdated: selectName(root.audioName)
        enabled: !checkBox.checked && !root.disable
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
            onChanged: root.changeVolume(), modified()
            visible: parameterVisible
            enabled: !checkBox.checked && !root.disable
        }
        Layout_AudioParameter {
            id: pitchGroup
            width: volumeGroup.width
            title: qsTr("Pitch")
            hint: qsTr("Pitch for audio playback.")
            minimumValue: 10 
            maximumValue: 200
            stepSize: 10
            suffix: " %"
            value: root.pitch
            onChanged: root.changePitch(), modified()
            visible: parameterVisible
            enabled: !checkBox.checked && !root.disable
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
            onChanged: root.changePan(), modified()
            visible: parameterVisible
            enabled: !checkBox.checked && !root.disable
        }
        GroupBox {
            width: 120
            height: 40
            ObjCheckBox {
                id: checkBox
                text: qsTr("Stop Sound")
                hint: qsTr("")
                y: -14
                x: 2

                onCheckedChanged: {
                    root.stopSound = checked
                    modified()
                }
            }
            enabled: !root.disable && !root.disableStopSound
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
        modified()
    }

    function stop() {
        AudioPlayer.stop(subFolder);
        playingAudioName = "";
        modified()
    }

    function changeVolume() {
        volume = volumeGroup.value;
        changePlayingAudio();
        modified()
    }

    function changePitch() {
        pitch = pitchGroup.value;
        changePlayingAudio();
        modified()
    }

    function changePan() {
        pan = panGroup.value;
        changePlayingAudio();
        modified()
    }

    function updateAudioName() {
        root.audioName = listBox.currentBaseName;
        modified()
    }

    function changePlayingAudio() {
        if (playingAudioName === audioName) {
            play();
            modified()
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
