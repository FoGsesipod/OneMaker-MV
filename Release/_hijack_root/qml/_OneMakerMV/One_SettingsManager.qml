pragma Singleton
import QtQuick 2.3
import Tkool.rpg 1.0
import "../Main"
import "../Singletons"

QtObject {
    id: root

    readonly property url storageLocation: TkoolAPI.pathToUrl(TkoolAPI.standardDocumentsLocation() + "/OneMakerMV/")
    readonly property string settingsFileName: "OneMakerMV-Settings.json"
    readonly property url fullPath: storageLocation + settingsFileName

    property var settingData
    property var defaultSettings: dataObject

    property bool corePluginDetected: false

    Component.onCompleted: {
        defaultSettings = {
            animationScreenBlendMode: {
                default: 1,
            },
            eventCommandSelect: {
                combinedEnabled: false,
                width: 508
            },
            maxLevel: {
                maximun: 99
            },
            selfVariableNaming: {
                namingScheme: [
                    'Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'
                ]
            },
            selfSwitchNaming: {
                enabled: false,
                namingScheme: [
                    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
                ]
            },
            soundSlotNaming: {
                namingScheme: [
                    'Zero', 'One', 'Two', 'Three'
                ]
            },
            imagePack: {
                userSelection: 'Default',
                arrayIndex: 0
            },
            windowSizes: {
                defaultWidthIncrease: 200,
                defaultHeightIncrease: 200,
                alternativeWidthIncrease: 100,
                alternativeHeightIncrease: 100,
                groupAnimationTimingsListBoxWidth: 298,
                groupNoteDatabaseWidth: 620,
                groupNoteDatabaseX: -420,
                groupEffectsListBoxWidth: 116,
                groupTraitsListBoxWidth: 116,
                layoutEventEditorNoteWidth: 460,
                globalDisable: false
            },
            workingMode: {
                expectedContext: true,
                faceImageBoxChange: true,
                removeActionPatterns: false,
                changeTextPreviewFont: true,
                customEventCommands: true
            }
        }
        loadConfiguration()
    }

    function getSetting(key, identifier) {
        return settingData[key][identifier];
    }

    function getArraySetting(key, identifier) {
        return JSON.stringify(settingData[key][identifier])
    }

    function getWindowSetting(identifier) {
        return settingData["windowSizes"]["globalDisable"] ? 0 : settingData["windowSizes"][identifier];
    }

    function getWorkingModeSetting(identifier) {
        return settingData["workingMode"]["expectedContext"] ? settingData["workingMode"][identifier] : false;
    }

    function setSetting(key, identifier, value) {
        settingData[key][identifier] = value;
        updateConfigurationFile();
    }

    function setArraySetting(key, identifier, list) {
        settingData[key][identifier] = JSON.parse(list);
        updateConfigurationFile();
    }

    function updateConfigurationFile() {
        TkoolAPI.writeFile(fullPath, JSON.stringify(settingData));
    }

    function resetSettings() {
        TkoolAPI.removeFile(fullPath);
        loadConfiguration();
    }

    function loadConfiguration() {
        if (!TkoolAPI.isDirectoryExists(storageLocation) || !TkoolAPI.isFileExists(fullPath)) {
            TkoolAPI.createDirectories(storageLocation);
            TkoolAPI.writeFile(fullPath, JSON.stringify(defaultSettings));
        }
        settingData = JSON.parse(TkoolAPI.readFile(fullPath));
        checkConfiguration()
    }

    function checkConfiguration() {
        var defaultKeys = Object.keys(defaultSettings)
        var needsUpdate = false
        defaultKeys.forEach(function(key) {
            if (!settingData.hasOwnProperty(key)) {
                settingData[key] = defaultSettings[key];
                needsUpdate = true;
            }
            else {
                var defaultIdentifier = Object.keys(defaultSettings[key])
                defaultIdentifier.forEach(function(identifier) {
                    if (!settingData[key].hasOwnProperty(identifier)) {
                        settingData[key][identifier] = defaultSettings[key][identifier];
                        needsUpdate = true;
                    }
                })
            }
        })
        if (needsUpdate) {
            updateConfigurationFile();
        }
    }

    function findCorePlugin() {
        var dataArray = DataManager.plugins;
        
        if (dataArray[0].name === "OneMakerMV-Core" && dataArray[0].status) {
            corePluginDetected = true;
        }
        else {
            corePluginDetected = false;
        }
    }

    function detectCorePluginActivationStatus() {
        return corePluginDetected;
    }

    function enableEventCommands(code) {
        var ids1 = [357, 358, 1000, 1002];
        var ids2 = getWorkingModeSetting("customEventCommands") ? [] : [1001, 1003, 1004]

        for (var i = 0; i < ids1.length; i++) {
            if (code === ids1[i]) {
                if (!corePluginDetected) {
                    return false;
                }
            }
        }

        for (var i = 0; i < ids2.length; i++) {
            if (code === ids2[i]) {
                return false;
            }
        }

        return true;
    }
}