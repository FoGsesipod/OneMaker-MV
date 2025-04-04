import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Singletons"
import "../_OneMakerMV"

DialogBoxRow {
    id: root

    property string subFolder: ""
    property bool expandedInformation: subFolder.toLowerCase() === "bgm" || subFolder.toLowerCase() === "bgs"

    property string audioName: ""
    property int audioVolume: 90
    property int audioPitch: 100
    property int audioPan: 0
    property bool stopSound: false

    property int fadeInValue: 0
    property int fadeOutValue: 0
    property bool saveSound: false
    property bool replaySound: false
    property int saveSlot: 0
    
    property string playingAudioName: ""

    property bool loaded: false

    signal modified(var key)

    ControlsColumn {
        ControlsRow {
            FileListBox {
                id: listBox
                width: 200
                height: expandedInformation ? 402 : 522
                allowedSuffixes: ["ogg"]
                folder: DataManager.projectUrl + "audio/" + subFolder

                onCurrentBaseNameChanged: root.updateAudioName()
                onDoubleClicked: root.play()
                onUpdated: selectName(root.audioName)
            }

            GroupBoxColumn {
                ControlsColumn {
                    Button {
                        id: playButton
                        width: 120
                        text: qsTr("Play")
                        hint: qsTr("Play the selected file.")
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
                    value: root.audioVolume
                    onChanged: root.changeVolume()
                    enabled: enableState("fadeInValue")
                }
                Layout_AudioParameter {
                    id: pitchGroup
                    width: volumeGroup.width
                    title: qsTr("Pitch")
                    hint: qsTr("Pitch for audio playback")
                    minimumValue: 5
                    maximumValue: 195
                    stepSize: 5
                    suffix: " %"
                    value: root.audioPitch
                    onChanged: root.changePitch()
                    enabled: enableState("fadeInValue")
                }
                Layout_AudioParameter {
                    id: panGroup
                    width: volumeGroup.width
                    title: qsTr("Pan")
                    hint: qsTr("Pan for audio playback.")
                    minimumValue: -100
                    maximumValue: 100
                    stepSize: 10
                    tickSpan: 20
                    value: root.audioPan
                    onChanged: root.changePan()
                    enabled: enableState("fadeInValue")
                }
                GroupBox {
                    width: 120
                    height: 40
                    CheckBox {
                        id: stopSoundBox
                        text: qsTr("Stop " + subFolder)
                        hint: qsTr("")
                        checked: root.stopSound
                        enabled: enableState("stopSound")
                        y: -14
                        x: 2

                        onCheckedChanged: {
                            if (root.stopSound != checked) {
                                root.stopSound = checked;
                                root.modified("stopSound");
                            }
                        }
                    }
                }
            }
        }
        ControlsRow {
            visible: expandedInformation
            SoundManagerDuration {
                id: fadeIn
                title: qsTr("Fade In Duration")
                hint: qsTr("Duration of the Fade In in seconds.")
                unit: qsTr("seconds")
                value: root.fadeInValue
                enabled: enableState("fadeInValue")

                onValueChanged: {
                    root.fadeInValue = value;
                    root.modified("fadeInValue");
                }
            }
            SoundManagerDuration {
                id: fadeOut
                title: qsTr("Fade Out Duration")
                hint: qsTr("Duration of the Fade Out in seconds.")
                unit: qsTr("seconds")
                value: root.fadeOutValue
                enabled: enableState("fadeOutValue")

                onValueChanged: {
                    root.fadeOutValue = value;
                    root.modified("fadeOutValue");
                }
            }
        }
        ControlsRow {
            visible: expandedInformation
            GroupBox {
                width: 120
                height: 60
                CheckBox {
                    id: saveSoundBox
                    text: qsTr("Save " + subFolder)
                    hint: qsTr("")
                    y: -18
                    x: 2
                    checked: root.saveSound
                    enabled: enableState("saveSound")

                    onCheckedChanged: {
                        if (root.saveSound != checked) {
                            root.saveSound = checked;
                            root.modified("saveSound");
                        }
                    }
                }
                CheckBox {
                    id: replaySoundBox
                    text: qsTr("Replay " + subFolder)
                    hint: qsTr("")
                    y: 8
                    x: 2
                    checked: root.replaySound
                    enabled: enableState("replaySound")

                    onCheckedChanged: {
                        if (root.replaySound != checked) {
                            root.replaySound = checked;
                            root.modified("replaySound");
                        }
                    }
                }
            }
            GroupBox {
                width: 207
                height: 60
                ObjComboBox {
                    id: saveSlotBox
                    title: qsTr("Save Slot")
                    hint: qsTr("")
                    model: OneMakerMVSettings.getSetting("soundSlotNaming", "namingScheme")
                    currentIndex: root.saveSlot
                    itemWidth: 187
                    y: -26
                    enabled: root.saveSound || root.replaySound

                    onCurrentIndexChanged: {
                        root.saveSlot = currentIndex;
                        root.modified("saveSlot");
                    }
                }
            }
        }
    }

    function play() {
        var audio = {
            name: audioName,
            volume: audioVolume,
            pitch: audioPitch,
            pan: audioPan
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
        audioVolume = volumeGroup.value;
        changePlayingAudio();
        modified("audioVolume")
    }

    function changePitch() {
        audioPitch = pitchGroup.value;
        changePlayingAudio();
        modified("audioPitch")
    }

    function changePan() {
        audioPan = panGroup.value;
        changePlayingAudio();
        modified("audioPan")
    }

    function updateAudioName() {
        audioName = listBox.currentBaseName;
        modified("audioName")
    }

    function changePlayingAudio() {
        if (playingAudioName === audioName) {
            play();
            modified("audioName")
        }
    }

    function enableState(ignored) {
        var states = ["fadeInValue", "fadeOutValue", "saveSound", "replaySound", "stopSound"];

        for (var i = 0; i < states.length; i++) {
            var stateName = states[i];

            if (stateName === ignored) {
                continue;
            }

            if (root[stateName]) {
                return false;
            }
        }

        return true
    }
}