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
    property int audioVolume: 90
    property int audioPitch: 100
    property int audioPan: 0
    property bool stopSound: false

    property int fadeInValue: 0
    property int fadeOutValue: 0
    property bool saveSound: false
    property bool replaySound: false
    property int saveSlot: 0

    TabView {
        id: tabView
        width: 352
        height: 576
        Tab {
            id: bgmTab
            title: "BGM"
            TabColumn {
                Layout_SoundManager {
                    id: bgmSelector
                    subFolder: "Bgm"
                    audioName: root.audioName
                    audioVolume: root.audioVolume
                    audioPitch: root.audioPitch
                    audioPan: root.audioPan
                    stopSound: root.stopSound
                    fadeInValue: root.fadeInValue
                    fadeOutValue: root.fadeOutValue
                    saveSound: root.saveSound
                    replaySound: root.replaySound
                    saveSlot: root.saveSlot

                    onModified: {
                        updateData(this, key);
                    }

                    Component.onCompleted: {
                        firstLoadFix(this, true)
                    }
                }
            }
        }
        Tab {
            id: bgsTab
            title: "BGS"
            TabColumn {
                Layout_SoundManager {
                    id: bgmSelector
                    subFolder: "Bgs"
                    audioName: root.audioName
                    audioVolume: root.audioVolume
                    audioPitch: root.audioPitch
                    audioPan: root.audioPan
                    stopSound: root.stopSound
                    fadeInValue: root.fadeInValue
                    fadeOutValue: root.fadeOutValue
                    saveSound: root.saveSound
                    replaySound: root.replaySound
                    saveSlot: root.saveSlot

                    onModified: {
                        updateData(this, key);
                    }

                    Component.onCompleted: {
                        firstLoadFix(this, true)
                    }
                }
            }
        }
        Tab {
            id: meTab
            title: "ME"
            TabColumn {
                Layout_SoundManager {
                    id: bgmSelector
                    subFolder: "Me"
                    audioName: root.audioName
                    audioVolume: root.audioVolume
                    audioPitch: root.audioPitch
                    audioPan: root.audioPan
                    stopSound: root.stopSound

                    onModified: {
                        updateData(this, key);
                    }

                    Component.onCompleted: {
                        firstLoadFix(this, false)
                    }
                }
            }
        }
        Tab {
            id: seTab
            title: "SE"
            TabColumn {
                Layout_SoundManager {
                    id: bgmSelector
                    subFolder: "Se"
                    audioName: root.audioName
                    audioVolume: root.audioVolume
                    audioPitch: root.audioPitch
                    audioPan: root.audioPan
                    stopSound: root.stopSound

                    onModified: {
                        updateData(this, key);
                    }

                    Component.onCompleted: {
                        firstLoadFix(this, false)
                    }
                }
            }
        }

        onCurrentIndexChanged: {
            switch (currentIndex) {
                case 0:
                    obtainTabData(bgmTab, true);
                    break;
                case 1:
                    obtainTabData(bgsTab, true);
                    break;
                case 2:
                    obtainTabData(meTab, false);
                    break;
                case 3:
                    obtainTabData(seTab, false);
                    break;
            }
        }
    }

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            switch (params[0]) {
                case 0:
                    tabView.currentIndex = 0;
                    var control = bgmTab.children[0].children[0];
                    switch (params[1]) {
                        case 0:
                            control.stopSound = true;
                            break;
                        case 1:
                            control.saveSound = true;
                            control.saveSlot = params[2];
                            break;
                        case 2:
                            control.replaySound = true;
                            control.saveSlot = params[2];
                            break;
                        case 3:
                            control.fadeOutValue = params[2];
                            break;
                        case 4:
                            var audio = params[2];
                            control.audioName = audio.name;
                            control.audioVolume = audio.volume;
                            control.audioPitch = audio.pitch;
                            control.audioPan = audio.pan;

                            if (params[3]) {
                                control.fadeInValue = params[3];
                            }
                            break;
                    }
                    updateData(control, true);
                    break;
                case 1:
                    tabView.currentIndex = 1;
                    var control = bgsTab.children[0].children[0];
                    switch (params[1]) {
                        case 0:
                            control.stopSound = true;
                            break;
                        case 1:
                            control.saveSound = true;
                            control.saveSlot = params[2];
                        case 2:
                            control.replaySound = true;
                            control.saveSlot = params[2];
                        case 3:
                            control.fadeOutValue = params[2];
                            break;
                        case 4:
                            var audio = params[2];
                            control.audioName = audio.name;
                            control.audioVolume = audio.volume;
                            control.audioPitch = audio.pitch;
                            control.audioPan = audio.pan;

                            if (params[3]) {
                                control.fadeInValue = params[3];
                            }
                            break;
                    }
                    updateData(control, true);
                    break;
                case 2:
                    tabView.currentIndex = 2;
                    var control = meTab.children[0].children[0];
                    switch (params[1]) {
                        case 0:
                            control.stopSound = true;
                            break;
                        case 1:
                            var audio = params[2];
                            control.audioName = audio.name;
                            control.audioVolume = audio.volume;
                            control.audioPitch = audio.pitch;
                            control.audioPan = audio.pan;
                            break;
                    }
                    updateData(control, false)
                    break;
                case 3:
                    tabView.currentIndex = 3;
                    var control = seTab.children[0].children[0];
                    switch (params[1]) {
                        case 0: 
                            control.stopSound = true;
                            break;
                        case 1:
                            var audio = params[2];
                            control.audioName = audio.name;
                            control.audioVolume = audio.volume;
                            control.audioPitch = audio.pitch;
                            control.audioPan = audio.pan;
                            break;
                    }
                    updateData(control, false)
                    break;
            }
        }
    }

    onSave: {
        makeSimpleEventData();

        var params = eventData[0].parameters;
        switch (tabView.currentIndex) {
            case 0:
                params[0] = 0;
                if (root.stopSound) {
                    params[1] = 0;
                }
                else if (root.saveSound) {
                    params[1] = 1;
                    params[2] = root.saveSlot;
                }
                else if (root.replaySound) {
                    params[1] = 2;
                    params[2] = root.saveSlot;
                }
                else if (root.fadeOutValue > 0) {
                    params[1] = 3;
                    params[2] = root.fadeOutValue;
                }
                else {
                    params[1] = 4;
                    var audio = {};
                    audio.name = root.audioName;
                    audio.volume = root.audioVolume;
                    audio.pitch = root.audioPitch;
                    audio.pan = root.audioPan;
                    params[2] = audio;

                    if (root.fadeInValue > 0) {
                        params[3] = root.fadeInValue;
                    }
                }
                break;
            case 1:
                params[0] = 1;
                if (root.stopSound) {
                    params[1] = 0;
                }
                else if (root.saveSound) {
                    params[1] = 1;
                    params[2] = root.saveSlot;
                }
                else if (root.replaySound) {
                    params[1] = 2;
                    params[2] = root.saveSlot;
                }
                else if (root.fadeOutValue > 0) {
                    params[1] = 3;
                    params[2] = root.fadeOutValue;
                }
                else {
                    params[1] = 4;
                    var audio = {};
                    audio.name = root.audioName;
                    audio.volume = root.audioVolume;
                    audio.pitch = root.audioPitch;
                    audio.pan = root.audioPan;
                    params[2] = audio;

                    if (root.fadeInValue > 0) {
                        params[3] = root.fadeInValue;
                    }
                }
                break;
            case 2:
                params[0] = 2;
                if (root.stopSound) {
                    params[1] = 0;
                }
                else {
                    params[1] = 1;
                    var audio = {};
                    audio.name = root.audioName;
                    audio.volume = root.audioVolume;
                    audio.pitch = root.audioPitch;
                    audio.pan = root.audioPan;
                    params[2] = audio;
                }
                break;
            case 3:
                params[0] = 3;
                if (root.stopSound) {
                    params[1] = 0;
                }
                else {
                    params[1] = 1;
                    var audio = {};
                    audio.name = root.audioName;
                    audio.volume = root.audioVolume;
                    audio.pitch = root.audioPitch;
                    audio.pan = root.audioPan;
                    params[2] = audio;
                }
                break;
        }
    }

    function firstLoadFix(control, extraInfo) {
        if (control.loaded) {
            return
        };
        var properties = ["audioName", "audioVolume", "audioPitch", "audioPan", "stopSound"];
        var defaultData = ["", 90, 100, 0, false];
        if (extraInfo) {
            properties.push("fadeInValue", "fadeOutValue", "saveSound", "replaySound", "saveSlot");
            defaultData.push(0, 0, false, false, 0);
        };

        for (var i = 0; i < properties.length; i++) {
            control[properties[i]] = defaultData[i];
        };
        control.loaded = true;
    }

    function obtainTabData(tab, extraInfo) {
        var properties = ["audioName", "audioVolume", "audioPitch", "audioPan", "stopSound"];
        if (extraInfo) {
            properties.push("fadeInValue", "fadeOutValue", "saveSound", "replaySound", "saveSlot");
        };

        var control = tab.children[0].children[0];

        if (control.loaded) {
            return;
        };

        for (var i = 0; i < properties.length; i++) {
            root[properties[i]] = control[properties[i]];
        };
    }

    function updateData(control, key) {
        var properties = ["audioName", "audioVolume", "audioPitch", "audioPan", "stopSound", "fadeInValue", "fadeOutValue", "saveSound", "replaySound", "saveSlot"];

        for (var i = 0; i < properties.length; i++) {
            var currentObject = properties[i];
            if (currentObject === key) {
                root[key] = control[key];
            };
        };
    }
}