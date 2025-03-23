pragma Singleton
import QtQuick 2.3
import Tkool.rpg 1.0

QtObject {
    readonly property url storageLocation: TkoolAPI.pathToUrl(TkoolAPI.standardDocumentsLocation() + "/OneMakerMV/")
    readonly property string settingsFileName: "OneMakerMV-Settings.json"
    readonly property url fullPath: storageLocation + settingsFileName

    property var settingData
    property var defaultSettings: dataObject

    Component.onCompleted: {
        defaultSettings = {
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
                groupNoteDatabaseWidth: 940,
                groupNoteDatabaseX: -420,
                groupEffectsListBoxWidth: 116,
                groupTraitsListBoxWidth: 116,
                layoutEventEditorNoteWidth: 460
            },
            workingMode: {
                expectedContext: true
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
}