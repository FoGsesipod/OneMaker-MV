import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Layouts"
import "../Singletons"

EventCommandBase {
    id: root

    property string audioName: ""
    property int volume: 90
    property int pitch: 100
    property int pan: 0
    property bool stopSound: false
    
    property int fadeBgmInValue: 0
    property int fadeBgmOutValue: 0
    property bool saveBgmSound: false
    property bool replayBgmSound: false
    property int saveBgmSlot: 0

    property int fadeBgsInValue: 0
    property int fadeBgsOutValue: 0
    property bool saveBgsSound: false
    property bool replayBgsSound: false
    property int saveBgsSlot: 0

    TabView {
        id: tabView
        width: 352
        height: 592

        Tab {
            id: bgmTab
            title: "BGM"
            TabColumn {
                id: tabColumn
                Layout_SoundManager {
                    id: bgmSelector
                    subFolder: "bgm"
                    restoreLast: true
                    fadeable: true
                    disable: saveBgm.checked || replayBgm.checked || fadeOut.value

                    Component.onCompleted: {
                        var item = nextItemInFocusChain();
                        item.forceActiveFocus();
                    }

                    onModified: {
                        root.audioName = audioName;
                        root.volume = volume;
                        root.pitch = pitch;
                        root.pan = pan;
                        root.stopSound = stopSound
                    }
                }

                ControlsRow {
                    Group_SoundManagerDuration {
                        id: fadeIn
                        title: qsTr("Fade In Duration")
                        hint: qsTr("Duration of the Fade In in seconds.")
                        unit: qsTr("seconds")
                        value: 0
                        enabled: !fadeOut.value && !saveBgm.checked && !replayBgm.checked && !stopSound

                        onValueChanged: {
                            root.fadeBgmInValue = value
                        }
                    }

                    Group_SoundManagerDuration {
                        id: fadeOut
                        title: qsTr("Fade Out Duration")
                        hint: qsTr("Duration of the Fade Out in seconds.")
                        unit: qsTr("seconds")
                        value: 0
                        enabled: !fadeIn.value && !saveBgm.checked && !replayBgm.checked && !stopSound
                        
                        onValueChanged: {
                            root.fadeBgmOutValue = value
                        }
                    }
                }
                ControlsRow {
                    GroupBox {
                        height: 60
                        ObjCheckBox {
                            id: saveBgm
                            text: qsTr("Save Bgm")
                            hint: qsTr("")
                            y: -18
                            x: 2
                            enabled: !fadeIn.value && !fadeOut.value && !replayBgm.checked && !stopSound

                            onCheckedChanged: {
                                root.saveBgmSound = checked
                            }
                        }
                        ObjCheckBox {
                            id: replayBgm
                            text: qsTr("Replay Bgm")
                            hint: qsTr("")
                            y: 8
                            x: 2
                            enabled: !fadeIn.value && !fadeOut.value && !saveBgm.checked && !stopSound

                            onCheckedChanged: {
                                root.replayBgmSound = checked
                            }
                        }
                    }
                    GroupBox {
                        width: 207
                        height: 60
                        ObjComboBox {
                            id: saveSlot
                            title: qsTr("Save Slot")
                            hint: qsTr("")
                            model: OneMakerMVSettings.getSetting("soundSlotNaming", "namingScheme")
                            itemWidth: 187
                            y: -21
                            enabled: saveBgm.checked || replayBgm.checked

                            onCurrentIndexChanged: {
                                root.saveBgmSlot = currentIndex
                            }
                        }
                    }
                }
            }   
        }
        Tab {
            id: bgsTab
            title: "BGS"
            TabColumn {
                Layout_SoundManager {
                    id: bgsSelector
                    subFolder: "bgs"
                    restoreLast: true
                    disable: saveBgs.checked || replayBgs.checked || fadeOut.value

                    onModified: {
                        root.audioName = audioName;
                        root.volume = volume;
                        root.pitch = pitch;
                        root.pan = pan;
                        root.stopSound = stopSound
                    }
                }

                ControlsRow {
                    Group_SoundManagerDuration {
                        id: fadeIn
                        title: qsTr("Fade In Duration")
                        hint: qsTr("Duration of the Fade In in seconds.")
                        value: 0
                        enabled: !fadeOut.value && !saveBgs.checked && !replayBgs.checked && !stopSound

                        onValueChanged: {
                            root.fadeBgsInValue = value
                        }
                    }

                    Group_SoundManagerDuration {
                        id: fadeOut
                        title: qsTr("Fade Out Duration")
                        hint: qsTr("Duration of the Fade Out in seconds.")
                        value: 0
                        enabled: !fadeIn.value && !saveBgs.checked && !replayBgs.checked && !stopSound

                        onValueChanged: {
                            root.fadeBgsOutValue = value
                        }
                    }
                }
                ControlsRow {
                    GroupBox {
                        height: 60
                        ObjCheckBox {
                            id: saveBgs
                            text: qsTr("Save Bgs ")
                            hint: qsTr("")
                            y: -18
                            x: 2
                            enabled: !fadeIn.value && !fadeOut.value && !replayBgs.checked && !stopSound

                            onCheckedChanged: {
                                root.saveBgsSound = checked
                            }
                        }
                        ObjCheckBox {
                            id: replayBgs
                            text: qsTr("Replay Bgs ")
                            hint: qsTr("")
                            y: 8
                            x: 2
                            enabled: !fadeIn.value && !fadeOut.value && !saveBgs.checked && !stopSound

                            onCheckedChanged: {
                                root.saveBgsSound = checked
                            }
                        }
                    }
                    GroupBox {
                        width: 207
                        height: 60
                        ObjComboBox {
                            id: saveSlot
                            title: qsTr("Save Slot")
                            hint: qsTr("")
                            model: OneMakerMVSettings.getSetting("soundSlotNaming", "namingScheme")
                            itemWidth: 187
                            y: -21
                            enabled: saveBgs.checked || replayBgs.checked

                            onCurrentIndexChanged: {
                                root.saveBgsSlot = currentIndex
                            }
                        }
                    }
                }
            }
        }
        Tab {
            id: meTab
            title: "ME"
            TabColumn {
                Layout_SoundManager {
                    id: meSelector
                    subFolder: "me"
                    restoreLast: true

                    onModified: {
                        root.audioName = audioName;
                        root.volume = volume;
                        root.pitch = pitch;
                        root.pan = pan;
                        root.stopSound = stopSound
                    }
                }
                
            }
        }
        Tab {
            id: seTab
            title: "SE"
            TabColumn {
                Layout_SoundManager {
                    id: seSelector
                    subFolder: "se"
                    restoreLast: true

                    onModified: {
                        root.audioName = audioName;
                        root.volume = volume;
                        root.pitch = pitch;
                        root.pan = pan;
                        root.stopSound = stopSound
                    }
                }
            }
        }

        onCurrentIndexChanged: {
            switch (currentIndex) {
                case 0:
                    root.audioName = bgmTab.children[0].children[0].audioName;
                    root.volume = bgmTab.children[0].children[0].volume;
                    root.pitch = bgmTab.children[0].children[0].pitch;
                    root.pan = bgmTab.children[0].children[0].pan;
                    root.stopSound = bgmTab.children[0].children[0].stopSound;
                    break;
                case 1:
                    root.audioName = bgsTab.children[0].children[0].audioName;
                    root.volume = bgsTab.children[0].children[0].volume;
                    root.pitch = bgsTab.children[0].children[0].pitch;
                    root.pan = bgsTab.children[0].children[0].pan;
                    root.stopSound = bgsTab.children[0].children[0].stopSound;
                    break;
                case 2:
                    root.audioName = meTab.children[0].children[0].audioName;
                    root.volume = meTab.children[0].children[0].volume;
                    root.pitch = meTab.children[0].children[0].pitch;
                    root.pan = meTab.children[0].children[0].pan;
                    root.stopSound = meTab.children[0].children[0].stopSound;
                    break;
                case 3:
                    root.audioName = seTab.children[0].children[0].audioName;
                    root.volume = seTab.children[0].children[0].volume;
                    root.pitch = seTab.children[0].children[0].pitch;
                    root.pan = seTab.children[0].children[0].pan;
                    root.stopSound = seTab.children[0].children[0].stopSound;
                    break;
            }
        }
    }

    onSave: {
        var params
        var scriptCommandText = "AudioManager."
        var ignore = false
        eventData = []

        eventData.push( makeCommand(355, 0, []) );
        params = eventData[0].parameters;

        switch (tabView.currentIndex) {
            case 0:
                if (stopSound) {
                    scriptCommandText += "stopBgm()";
                }
                else if (saveBgmSound) {
                    scriptCommandText = "$gameSystem._savedBgm" + saveBgmSlot + " = AudioManager.saveBgm()";
                }
                else if (replayBgmSound) {
                    eventData.push( makeCommand(655, 0, []) );
                    eventData.push( makeCommand(655, 0, []) );
                    params = eventData[1].parameters;
                    scriptCommandText = "if ($gameSystem._savedBgm" + saveBgmSlot + ") {";
                    params[0] = "  AudioManager.replayBgm($gameSystem._savedBgm" + saveBgmSlot + ")";
                    params = eventData[2].parameters;
                    params[0] = "}";

                    params = eventData[0].parameters;
                }
                else {
                    if (fadeBgmOutValue > 0) {
                        scriptCommandText += "fadeOutBgm(" + fadeBgmOutValue + ")";
                    }
                    else {
                        scriptCommandText += "playBgm( {name: '" + audioName + "', volume: " + volume + ", pitch: " + pitch + ", pan: " + pan + "} )";

                        if (fadeBgmInValue > 0) {
                            eventData.push( makeCommand(655, 0, []) );
                            params = eventData[1].parameters;
                            params[0] = "AudioManager.fadeInBgm(" + fadeBgmInValue + ")";

                            params = eventData[0].parameters;
                        }
                    }
                }
                break;
            case 1:
                if (stopSound) {
                    scriptCommandText += "stopBgs()";
                }
                else if (saveBgsSound) {
                    scriptCommandText = "$gameSystem._savedBgs" + saveBgsSlot + " = AudioManager.saveBgs()";
                }
                else if (replayBgsSound) {
                    eventData.push( makeCommand(655, 0, []) );
                    eventData.push( makeCommand(655, 0, []) );
                    params = eventData[1].parameters;
                    params[0] = "  AudioManager.replayBgs($gameSystem._savedBgs" + saveBgsSlot + ")";
                    scriptCommandText = "if ($gameSystem._savedBgs" + saveBgsSlot + ") {";
                    params = eventData[2].parameters;
                    params[0] = "}";

                    params = eventData[0].parameters;
                }
                else {
                    if (fadeBgsOutValue > 0) {
                        scriptCommandText += "fadeOutBgs(" + fadeBgsOutValue + ")";
                    }
                    else {
                        scriptCommandText += "playBgs( {name: '" + audioName + "', volume: " + volume + ", pitch: " + pitch + ", pan: " + pan + "} )";

                        if (fadeBgsInValue > 0 && !ignore) {
                            eventData.push( makeCommand(655, 0, []) );
                            params = eventData[1].parameters;
                            params[0] = "AudioManager.fadeInBgs(" + fadeBgsInValue + ")";

                            params = eventData[0].parameters;
                        }
                    }
                }
                break;
            case 2:
                if (stopSound) {
                    scriptCommandText += "stopMe()";
                }
                else {
                    scriptCommandText += "playMe( {name: '" + audioName + "', volume: " + volume + ", pitch: " + pitch + ", pan: " + pan + "} )";
                }
                break;
            case 3:
                if (stopSound) {
                    scriptCommandText += "stopSe()";
                }
                else {
                    scriptCommandText += "playSe( {name: '" + audioName + "', volume: " + volume + ", pitch: " + pitch + ", pan: " + pan + "} )";
                }
                break;
        }

        params[0] = scriptCommandText;
    }
}
