import QtQuick 2.3
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0
import Tkool.rpg 1.0
import "../BasicControls"
import "../Singletons"
import "../_OneMakerMV"

Item {
    id: root

    readonly property bool projectOpened: DataManager.projectOpened

    property bool mapEditEnabled: false
    property bool mapNewEnabled: false
    property bool mapCopyEnabled: false
    property bool mapPasteEnabled: false
    property bool mapDeleteEnabled: false
    property bool mapFindEnabled: false
    property bool mapFindNextEnabled: false

    property bool eventEditEnabled: false
    property bool eventNewEnabled: false
    property bool eventCutEnabled: false
    property bool eventCopyEnabled: false
    property bool eventPasteEnabled: false
    property bool eventDeleteEnabled: false
    property bool eventFindEnabled: false
    property bool eventFindNextEnabled: false

    property bool undoEnabled: false

    property int editMode: 0
    property int drawingTool: 0
    property real tileScale: 1

    readonly property real minimumTileScale: 5/48
    readonly property real maximumTileScale: 72/48

    readonly property var tileScaleTable: [
         5/48,  6/48,  7/48,  8/48,  9/48, 10/48, 11/48, 12/48,
        14/48, 16/48, 18/48, 20/48, 22/48, 24/48, 28/48, 32/48,
        36/48, 40/48, 44/48, 48/48, 54/48, 60/48, 66/48, 72/48
    ]

    property string appendTools: AppendSettings.storage.mvTools
    property var appendToolMenus: []
    property var appendToolButtons: []

    property var mapFindManager
    property var eventFindManager

    signal fileNew()
    signal fileOpen()
    signal fileClose()
    signal fileSave()
    signal fileDeployment()
    signal steamManagement()
    signal gameShare()
    signal monacaUpload()

    signal mapEdit()
    signal mapNew()
    signal mapLoadX()
    signal mapCopy()
    signal mapPaste()
    signal mapDelete()
    signal mapShift()
    signal mapGenerateDungeon()
    signal mapSaveAsImage()

    signal eventEdit()
    signal eventNew()
    signal eventCut()
    signal eventCopy()
    signal eventPaste()
    signal eventDelete()
    signal eventSetStartingPosition(var name)
    signal eventQuickCreation(var name)

    signal editUndo()

    signal toolDatabase()
    signal toolPluginManager()
    signal toolSoundTest()
    signal toolEventSearcher()
    signal toolCharacterGenerator()
    signal toolResourceManager()
    signal toolAppendTools()
    signal toolOptions()
    signal gamePlaytest()
    signal gameOpenFolder()
    signal helpContents()
    // [OneMaker MV] - Add Menu Signals
    signal oneMakerMV_AnimationScreen()
    signal oneMakerMV_EventCommandSelectPage()
    signal oneMakerMV_MaxLimits()
    signal oneMakerMV_ArrayNames()
    signal oneMakerMV_ImageSelection()
    signal oneMakerMV_WindowSizes()
    signal oneMakerMV_WorkingMode()
    signal oneMakerMV_ResetSettings()

    signal steamWindow()
    signal tutorial()

    signal about()
    signal exit()

    signal launchTool(string path, string appName)

    readonly property url imagePath: ImagePack.selectedImagePack // [OneMaker MV] - Obtain Image Pack

    Settings {
        property alias editMode: root.editMode
        property alias drawingTool: root.drawingTool
        property alias tileScale: root.tileScale
    }

    ExclusiveGroup {
        id: exclusiveModeGroup
    }
    ExclusiveGroup {
        id: exclusiveDrawGroup
    }
    ExclusiveGroup {
        id: exclusiveScaleGroup
    }

    property MenuBar menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem { action: fileNew }
            MenuItem { action: fileOpen }
            MenuItem { action: fileClose }
            MenuItem { action: fileSave }
            MenuSeparator {}
            MenuItem { action: fileDeployment }
            MenuItem {
                action: steamManagement
                visible: TkoolAPI.isSteamRelease();
            }
            MenuItem { action: gameShare; visible: false }
            MenuItem { action: monacaUpload; visible: (TkoolAPI.isAllowUpload() & TkoolAPI.Monaca) != 0 && (SettingsManager.storage.uploadOperationMonaca & TkoolAPI.Monaca) != 0 }
            MenuSeparator { visible: Qt.platform.os !== "osx" }
            MenuItem { action: exit }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem { action: editUndo }
            MenuSeparator {}
            MenuItem { action: editCut }
            MenuItem { action: editCopy }
            MenuItem { action: editPaste }
            MenuItem { action: editDelete }
            MenuSeparator {}
            MenuItem { action: editFind }
            MenuItem { action: editFindNext }
            MenuItem { action: editFindPrevious }
        }
        Menu {
            title: qsTr("Mode")
            MenuItem { action: modeMap }
            MenuItem { action: modeEvent }
        }
        Menu {
            title: qsTr("Draw")
            MenuItem { action: drawPencil }
            MenuItem { action: drawRectangle }
            MenuItem { action: drawEllipse }
            MenuItem { action: drawFloodFill }
            MenuItem { action: drawShadowPen }
        }
        Menu {
            title: qsTr("Scale")
            MenuItem { action: scaleZoomIn }
            MenuItem { action: scaleZoomOut }
            MenuItem { action: scaleActualSize }
        }
        Menu {
            id: toolMenu
            title: qsTr("Tools")
            MenuItem { action: toolDatabase }
            MenuItem { action: toolPluginManager }
            MenuItem { action: toolSoundTest }
            MenuItem { action: toolEventSearcher }
            MenuItem { action: toolCharacterGenerator }
            MenuItem { action: toolResourceManager }
            MenuSeparator { visible: TkoolAPI.mvToolsEnabled() }
            MenuItem { id: appendMenuItem; action: appendTools; visible: TkoolAPI.mvToolsEnabled() }
            MenuSeparator { visible: Qt.platform.os !== "osx" }
            MenuItem { action: toolOptions }
        }
        Menu {
            title: qsTr("Game")
            MenuItem { action: gamePlaytest }
            MenuSeparator {}
            MenuItem { action: gameOpenFolder }
        }
        Menu {
            title: qsTr("Help")
            MenuItem { action: helpContents }
            MenuItem { action: tutorial; visible: TutorialManager.enabled }
            MenuSeparator {}
            MenuItem { action: about }
        }
        // [OneMaker MV] - OneMakerMV Menu Bar
        Menu {
            title: qsTr("OneMaker MV")
            MenuItem { action: oneMakerMV_AnimationScreen }
            MenuItem { action: oneMakerMV_EventCommandMenu }
            MenuItem { action: oneMakerMV_MaxLimitsMenu }
            MenuItem { action: oneMakerMV_ArrayNamesMenu }
            MenuItem { action: oneMakerMV_ImageSelectionMenu }
            MenuItem { action: oneMakerMV_WindowMenu }
            MenuItem { action: oneMakerMV_WorkingModeMenu }
            MenuItem { action: oneMakerMV_ResetSettings }
        }
    }

    property Menu mapContextMenu: Menu {
        MenuItem { action: mapEdit }
        MenuItem { action: mapNew }
        MenuItem { action: mapLoadX }
        MenuSeparator {}
        MenuItem { action: editCopy }
        MenuItem { action: editPaste }
        MenuItem { action: editDelete }
        MenuSeparator {}
        MenuItem { action: editFind }
        MenuItem { action: editFindNext }
        MenuItem { action: editFindPrevious }
        MenuSeparator {}
        MenuItem { action: mapShift }
        MenuItem { action: mapGenerateDungeon }
        MenuItem { action: mapSaveAsImage }
    }

    property Menu eventContextMenu: Menu {
        MenuItem { action: eventEdit; enabled: eventEditEnabled }
        MenuItem { action: eventNew; enabled: eventNewEnabled }
        MenuSeparator {}
        MenuItem { action: editCut }
        MenuItem { action: editCopy }
        MenuItem { action: editPaste }
        MenuItem { action: editDelete }
        MenuSeparator {}
        MenuItem { action: editFind }
        MenuItem { action: editFindNext }
        MenuItem { action: editFindPrevious }
        MenuSeparator {}
        Menu {
            title: qsTr("Quick Event Creation")
            MenuItem {
                text: qsTr("Transfer") + "..."
                shortcut: "Ctrl+1"
                enabled: eventNewEnabled
                onTriggered: {
                    eventQuickCreation("transfer");
                    TutorialManager.onActionTriggered("Transfer", this);
                }
            }
            MenuItem {
                text: qsTr("Door") + "..."
                shortcut: "Ctrl+2"
                enabled: eventNewEnabled
                onTriggered: {
                    eventQuickCreation("door");
                    TutorialManager.onActionTriggered("Door", this);
                }
            }
            MenuItem {
                text: qsTr("Treasure") + "..."
                shortcut: "Ctrl+3"
                enabled: eventNewEnabled
                onTriggered: {
                    eventQuickCreation("treasure");
                    TutorialManager.onActionTriggered("Treasure", this);
                }
            }
            MenuItem {
                text: qsTr("Inn") + "..."
                shortcut: "Ctrl+4"
                enabled: eventNewEnabled
                onTriggered: {
                    eventQuickCreation("inn");
                    TutorialManager.onActionTriggered("Inn", this);
                }
            }
            enabled: eventNewEnabled
        }
        MenuSeparator {}
        Menu {
            title: qsTr("Set Starting Position")
            MenuItem {
                text: Constants.playerName
                onTriggered: {
                    eventSetStartingPosition("player");
                    TutorialManager.onActionTriggered("Set Starting Position Player", this);
                }
            }
            MenuItem {
                text: Constants.boatName
                onTriggered: {
                    eventSetStartingPosition("boat");
                    TutorialManager.onActionTriggered("Set Starting Position Boat", this);
                }
            }
            MenuItem {
                text: Constants.shipName
                onTriggered: {
                    eventSetStartingPosition("ship");
                    TutorialManager.onActionTriggered("Set Starting Position Ship", this);
                }
            }
            MenuItem {
                text: Constants.airshipName
                onTriggered: {
                    eventSetStartingPosition("airship");
                    TutorialManager.onActionTriggered("Set Starting Position Airship", this);
                }
            }
            enabled: eventNewEnabled
        }
    }

    property ToolBar toolBar: ToolBar {
        Row {
            ToolButton {
                action: fileNew
                iconSource: toolBarIconSource("file-new")
            }
            ToolButton {
                action: fileOpen
                iconSource: toolBarIconSource("file-open")
            }
            ToolButton {
                action: fileSave
                iconSource: toolBarIconSource("file-save")
            }
            ToolBarSeparator {}
            ToolButton {
                action: editCut
                iconSource: toolBarIconSource("edit-cut")
            }
            ToolButton {
                action: editCopy
                iconSource: toolBarIconSource("edit-copy")
            }
            ToolButton {
                action: editPaste
                iconSource: toolBarIconSource("edit-paste")
            }
            ToolBarSeparator {}
            ToolButton {
                action: editUndo
                iconSource: toolBarIconSource("edit-undo")
            }
            ToolBarSeparator {}
            ToolButton {
                action: modeMap
                iconSource: toolBarIconSource("mode-map")
            }
            ToolButton {
                action: modeEvent
                iconSource: toolBarIconSource("mode-event")
            }
            ToolBarSeparator {}
            ToolButton {
                action: drawPencil
                iconSource: toolBarIconSource("draw-pencil")
            }
            ToolButton {
                action: drawRectangle
                iconSource: toolBarIconSource("draw-rectangle")
            }
            ToolButton {
                action: drawEllipse
                iconSource: toolBarIconSource("draw-ellipse")
            }
            ToolButton {
                action: drawFloodFill
                iconSource: toolBarIconSource("draw-floodfill")
            }
            ToolButton {
                action: drawShadowPen
                iconSource: toolBarIconSource("draw-shadowpen")
            }
            ToolBarSeparator {}
            ToolButton {
                action: scaleZoomIn
                iconSource: toolBarIconSource("scale-zoomin")
            }
            ToolButton {
                action: scaleZoomOut
                iconSource: toolBarIconSource("scale-zoomout")
            }
            ToolButton {
                action: scaleActualSize
                iconSource: toolBarIconSource("scale-actualsize")
            }
            ToolBarSeparator {}
            ToolButton {
                action: toolDatabase
                iconSource: toolBarIconSource("tools-database")
            }
            ToolButton {
                action: toolPluginManager
                iconSource: toolBarIconSource("tools-pluginmanager")
            }
            ToolButton {
                action: toolSoundTest
                iconSource: toolBarIconSource("tools-soundtest")
            }
            ToolButton {
                action: toolEventSearcher
                iconSource: toolBarIconSource("tools-eventsearcher")
            }
            ToolButton {
                action: toolResourceManager
                iconSource: toolBarIconSource("tools-resourcemanager")
            }
            ToolButton {
                action: toolCharacterGenerator
                iconSource: toolBarIconSource("tools-charactergenerator")
            }
            ToolBarSeparator {}
            ToolButton {
                action: gamePlaytest
                iconSource: toolBarIconSource("game-playtest")
            }
            Row {
                id: appendToolButtons
                ToolBarSeparator {}
            }
        }
    }

    function toolBarIconSource(name) {
        var map = ThemeManager.currentTheme.toolbarMap;
        if (map && map[name])
            return ImagePack.selectedImagePack + "toolbar/%1.png".arg(map[name]); // [OneMaker MV] - Obtain Image Pack
        return ImagePack.selectedImagePack + "toolbar/%1.png".arg(name); // [OneMaker MV] - Obtain Image Pack
    }

    Action {
        id: fileNew
        text: qsTr("New Project") + "..."
        hint: qsTr("Creates a new project.")
        shortcut: StandardKey.New
        onTriggered: {
            root.fileNew();
            TutorialManager.onActionTriggered("New Project", this);
        }
        enabled: true
    }
    Action {
        id: fileOpen
        text: qsTr("Open Project") + "..."
        hint: qsTr("Opens an existing project.")
        shortcut: StandardKey.Open
        onTriggered: {
            projectManager.confirmSave(function() {
            root.fileOpen();
            TutorialManager.onActionTriggered("Open Project", this);
         });
        }
        enabled: true
    }
    Action {
        id: fileClose
        text: qsTr("Close Project")
        hint: qsTr("Closes the current project.")
        onTriggered: {
            root.fileClose();
            TutorialManager.onActionTriggered("Close Project", this);
        }
        enabled: projectOpened
    }
    Action {
        id: fileSave
        text: qsTr("Save Project")
        hint: qsTr("Saves the current project.")
        shortcut: StandardKey.Save
        onTriggered: {
            root.fileSave();
            TutorialManager.onActionTriggered("Save Project", this);
        }
        enabled: projectOpened
    }
    Action {
        id: fileDeployment
        text: qsTr("Deployment") + "..."
        hint: qsTr("Creates a distribution package.")
        onTriggered: {
            root.fileDeployment();
            TutorialManager.onActionTriggered("Deployment", this);
        }
        enabled: projectOpened
    }
    Action {
        id: steamManagement
        text: qsTr("Steam Management")
        hint: qsTr("Manage Your Steam Cloud.")
        onTriggered: root.steamWindow()
        enabled: true
    }
    Action {
        id: gameShare
        text: qsTr("Game Share(NICONICO)") + "..."
        hint: qsTr("Upload the game.")
        onTriggered: root.gameShare()
        enabled: projectOpened && ((SettingsManager.storage.uploadOperation & TkoolAPI.Atsumaal) != 0)
    }
    Action {
        id: monacaUpload
        text: qsTr("Monaca") + "..."
        hint: qsTr("Upload the game.")
        onTriggered: root.monacaUpload()
        enabled: projectOpened && ((SettingsManager.storage.uploadOperationMonaca & TkoolAPI.Monaca) != 0)
    }

    Action {
        id: mapEdit
        text: qsTr("Edit", "Edit Map") + "..."
        hint: qsTr("Changes the map settings.")
        shortcut: "Space"
        onTriggered: {
            root.mapEdit();
            TutorialManager.onActionTriggered("Edit Map", this);
        }
        enabled: mapEditEnabled
    }
    Action {
        id: mapNew
        text: qsTr("New", "New Map") + "..."
        hint: qsTr("Creates a new map.")
        shortcut: "Return"
        onTriggered: {
            root.mapNew();
            TutorialManager.onActionTriggered("New Map", this);
        }
        enabled: mapNewEnabled
    }
    Action {
        shortcut: "Enter"
        onTriggered: {
            root.mapNew();
            TutorialManager.onActionTriggered("New Map", this);
        }
        enabled: mapNewEnabled
    }
    Action {
        id: mapLoadX
        text: qsTr("Load") + "..."
        hint: qsTr("Adds a sample map as a new map.")
        onTriggered: {
            root.mapLoadX();
            TutorialManager.onActionTriggered("Load", this);
        }
        enabled: mapNewEnabled
    }
    Action {
        id: mapShift
        text: qsTr("Shift") + "..."
        hint: qsTr("Shifts the current map contents.")
        shortcut: "Ctrl+T"
        onTriggered: {
            root.mapShift();
            TutorialManager.onActionTriggered("mapShift", this);
        }
        enabled: mapEditEnabled
    }
    Action {
        id: mapGenerateDungeon
        text: qsTr("Generate Dungeon") + "..."
        hint: qsTr("Generates a dungeon in the current map.")
        shortcut: "Ctrl+D"
        onTriggered: {
            root.mapGenerateDungeon();
            TutorialManager.onActionTriggered("Generate Dungeon", this);
        }
        enabled: mapEditEnabled
    }
    Action {
        id: mapSaveAsImage
        text: qsTr("Save as Image") + "..."
        hint: qsTr("Saves the current map as a image file.")
        onTriggered: {
            root.mapSaveAsImage();
            TutorialManager.onActionTriggered("Save as Image", this);
        }
        enabled: mapEditEnabled
    }

    Action {
        id: eventEdit
        text: qsTr("Edit", "Edit Event") + "..."
        hint: qsTr("Changes the event settings.")
        shortcut: "Return"
        onTriggered: {
            root.eventEdit();
            TutorialManager.onActionTriggered("Edit Event", this);
        }
        enabled: eventEditEnabled
    }
    Action {
        id:eventEditEnter
        shortcut: "Enter"
        onTriggered: {
            root.eventEdit();
            TutorialManager.onActionTriggered("Edit Event", this);
        }
        enabled: eventEditEnabled
    }
    Action {
        id: eventNew
        text: qsTr("New", "New Event") + "..."
        hint: qsTr("Creates a new event.")
        shortcut: "Return"
        onTriggered: {
            root.eventNew();
            TutorialManager.onActionTriggered("eventNew", this);
        }
        enabled: eventNewEnabled
    }

    Action {
        id:eventNewEnter
        shortcut: "Enter"
        onTriggered: {
            root.eventNew();
            TutorialManager.onActionTriggered("eventNew", this);
        }
        enabled: eventNewEnabled
    }

    Action {
        id: editCut
        text: qsTr("Cut")
        hint: qsTr("Removes and copies the selection to the clipboard.")
        shortcut: StandardKey.Cut
        onTriggered: {
            root.eventCut();
            TutorialManager.onActionTriggered("editCut", this);
        }
        enabled: eventCutEnabled
    }
    Action {
        id: editCopy
        text: qsTr("Copy")
        hint: qsTr("Copies the selection to the clipboard.")
        shortcut: StandardKey.Copy
        onTriggered: {
            mapCopyEnabled ? root.mapCopy() : root.eventCopy();
            TutorialManager.onActionTriggered("editCopy", this);
        }
        enabled: mapCopyEnabled || eventCopyEnabled
    }
    Action {
        id: editPaste
        text: qsTr("Paste")
        hint: qsTr("Inserts the contents of the clipboard.")
        shortcut: StandardKey.Paste
        onTriggered: {
            mapPasteEnabled ? root.mapPaste() : root.eventPaste();
            TutorialManager.onActionTriggered("editPaste", this);
        }
        enabled: mapPasteEnabled || eventPasteEnabled
    }
    Action {
        id: editDelete
        text: qsTr("Delete")
        hint: qsTr("Removes the selection.")
        shortcut: StandardKey.Delete
        onTriggered: {
            mapDeleteEnabled ? root.mapDelete() : root.eventDelete();
            TutorialManager.onActionTriggered("editDelete", this);
        }
        enabled: mapDeleteEnabled || eventDeleteEnabled
    }
    Action {
        id: editDeleteBsckspace
        shortcut: "Backspace"
        onTriggered: {
            mapDeleteEnabled ? root.mapDelete() : root.eventDelete();
            TutorialManager.onActionTriggered("editDelete", this);
        }
        enabled: mapDeleteEnabled || eventDeleteEnabled
    }

    Action {
        id: editUndo
        text: qsTr("Undo")
        hint: qsTr("Reverses the last action.")
        shortcut: StandardKey.Undo
        onTriggered: {
            root.editUndo();
            TutorialManager.onActionTriggered("editUndo", this);
        }
        enabled: projectOpened && undoEnabled
    }
    Action {
        id: editFind
        text: qsTr("Find") + "..."
        hint: qsTr("Finds the specified text.")
        shortcut: StandardKey.Find
        onTriggered: {
            if (mapFindEnabled) {
                mapFindManager.find();
            } else if (eventFindEnabled) {
                eventFindManager.find();
            }
        }
        enabled: projectOpened && (mapFindEnabled || eventFindEnabled)
    }
    Action {
        id: editFindNext
        text: qsTr("Find Next")
        hint: qsTr("Searches for the next instance of the text you specified.")
        shortcut: StandardKey.FindNext
        onTriggered: {
            if (mapFindEnabled) {
                mapFindManager.findNext();
            } else if (eventFindEnabled) {
                eventFindManager.findNext();
            }
        }
        enabled: projectOpened && (
                     (mapFindEnabled && mapFindNextEnabled) ||
                     (eventFindEnabled && eventFindNextEnabled))
    }
    Action {
        id: editFindPrevious
        text: qsTr("Find Previous")
        hint: qsTr("Searches for the previous instance of the text you specified.")
        shortcut: StandardKey.FindPrevious
        onTriggered: {
            if (mapFindEnabled) {
                mapFindManager.findPrevious();
            } else if (eventFindEnabled) {
                eventFindManager.findPrevious();
            }
        }
        enabled: projectOpened && (
                     (mapFindEnabled && mapFindNextEnabled) ||
                     (eventFindEnabled && eventFindNextEnabled))
    }

    Action {
        id: modeMap
        text: qsTr("Map")
        hint: qsTr("Switches to the map editing mode.")
        shortcut: "F5"
        checkable: true
        exclusiveGroup: exclusiveModeGroup
        onTriggered: {
            editMode = 0;
            TutorialManager.onActionTriggered("Map", this);
        }
        checked: editMode === 0
        enabled: projectOpened
    }
    Action {
        id: modeEvent
        text: qsTr("Event")
        hint: qsTr("Switches to the event editing mode.")
        shortcut: "F6"
        checkable: true
        exclusiveGroup: exclusiveModeGroup
        onTriggered: {
            editMode = 1;
            TutorialManager.onActionTriggered("Event", this);
        }
        checked: editMode === 1
        enabled: projectOpened
    }

    Action {
        id: drawPencil
        text: qsTr("Pencil")
        hint: qsTr("Draws tiles freehand.")
        checkable: true
        exclusiveGroup: exclusiveDrawGroup
        onTriggered: {
            drawingTool = 0;
            TutorialManager.onActionTriggered("Pencil", this);
        }
        checked: drawingTool === 0
        enabled: projectOpened && editMode === 0
    }
    Action {
        id: drawRectangle
        text: qsTr("Rectangle")
        hint: qsTr("Draws a rectangle.")
        checkable: true
        exclusiveGroup: exclusiveDrawGroup
        onTriggered: {
            drawingTool = 1;
            TutorialManager.onActionTriggered("Rectangle", this);
        }
        checked: drawingTool === 1
        enabled: projectOpened && editMode === 0
    }
    Action {
        id: drawEllipse
        text: qsTr("Ellipse")
        hint: qsTr("Draws an ellipse.")
        checkable: true
        exclusiveGroup: exclusiveDrawGroup
        onTriggered: {
            drawingTool = 2;
            TutorialManager.onActionTriggered("Ellipse", this);
        }
        checked: drawingTool === 2
        enabled: projectOpened && editMode === 0
    }
    Action {
        id: drawFloodFill
        text: qsTr("Flood Fill")
        hint: qsTr("Fills the enclosed area.")
        checkable: true
        exclusiveGroup: exclusiveDrawGroup
        onTriggered: {
            drawingTool = 3;
            TutorialManager.onActionTriggered("Flood Fill", this);
        }
        checked: drawingTool === 3
        enabled: projectOpened && editMode === 0
    }
    Action {
        id: drawShadowPen
        text: qsTr("Shadow Pen")
        hint: qsTr("Adds or removes shadows of walls.")
        checkable: true
        exclusiveGroup: exclusiveDrawGroup
        onTriggered: {
            drawingTool = 4;
            TutorialManager.onActionTriggered("Shadow Pen", this);
        }
        checked: drawingTool === 4
        enabled: projectOpened && editMode === 0
    }

    Action {
        id: scaleZoomIn
        text: qsTr("Zoom In")
        hint: qsTr("Zooms in the map view.")
        shortcut: StandardKey.ZoomIn
        enabled: projectOpened && tileScale < maximumTileScale
        onTriggered: {
            doScaleZoomIn();
            TutorialManager.onActionTriggered("Zoom In", this);
        }
    }

    function doScaleZoomIn() {
        var length = tileScaleTable.length;
        for (var i = 0; i < length; i++) {
            var newScale = tileScaleTable[i];
            if (newScale > tileScale) {
                tileScale = newScale;
                break;
            }
        }
    }

    Action {
        id: scaleZoomOut
        text: qsTr("Zoom Out")
        hint: qsTr("Zooms out the map view.")
        shortcut: StandardKey.ZoomOut
        enabled: projectOpened && tileScale > minimumTileScale
        onTriggered: {
            doScaleZoomOut();
            TutorialManager.onActionTriggered("Zoom Out", this);
        }
    }

    function doScaleZoomOut() {
        var length = tileScaleTable.length;
        for (var i = 0; i < length; i++) {
            var newScale = tileScaleTable[length - 1 - i];
            if (newScale < tileScale) {
                tileScale = newScale;
                break;
            }
        }
    }

    Action {
        id: scaleActualSize
        text: qsTr("Actual Size")
        hint: qsTr("Displays the map at a scale of 1:1.")
        shortcut: "Ctrl+0"
        enabled: projectOpened && tileScale !== 1.0
        onTriggered: {
            tileScale = 1.0;
            TutorialManager.onActionTriggered("Actual Size", this);
        }
    }

    Action {
        id: toolDatabase
        text: qsTr("Database") + "..."
        hint: qsTr("Opens the database.")
        shortcut: "F9"
        onTriggered: {
            root.toolDatabase();
            TutorialManager.onActionTriggered("Database", this);
        }
        enabled: projectOpened
    }
    Action {
        id: toolPluginManager
        text: qsTr("Plugin Manager") + "..."
        hint: qsTr("Opens the plugin manager window.")
        shortcut: "F10"
        onTriggered: {
            root.toolPluginManager();
            TutorialManager.onActionTriggered("Plugin Manager", this);
        }
        enabled: projectOpened
    }
    Action {
        id: toolSoundTest
        text: qsTr("Sound Test") + "..."
        hint: qsTr("Opens the sound test window.")
        onTriggered: {
            root.toolSoundTest();
            TutorialManager.onActionTriggered("Sound Test", this);
        }
        enabled: projectOpened
    }
    Action {
        id: toolEventSearcher
        text: qsTr("Event Searcher") + "..."
        hint: qsTr("Opens the event searcher window.")
        onTriggered: {
            root.toolEventSearcher();
            TutorialManager.onActionTriggered("Event Searcher", this);
        }
        enabled: projectOpened
    }
    Action {
        id: toolCharacterGenerator
        text: qsTr("Character Generator") + "..."
        hint: qsTr("Opens the Character Generator window.")
        onTriggered: {
            root.toolCharacterGenerator();
            TutorialManager.onActionTriggered("Character Generator", this);
        }
        enabled: projectOpened
    }
    Action {
        id: toolResourceManager
        text: qsTr("Resource Manager") + "..."
        hint: qsTr("Opens the Resource Manager window.")
        onTriggered: {
            root.toolResourceManager();
            TutorialManager.onActionTriggered("Resource Manager", this);
        }
        enabled: projectOpened
    }
    Action {
        id: appendTools
        text: qsTr("RPG Maker MV Tools") + "..."
        hint: qsTr("Add external tools.")
        onTriggered: root.toolAppendTools()
        enabled: projectOpened
    }
    Action {
        id: toolOptions
        // On OS X, this item will automatically appear in the Application Menu.
        text: Qt.platform.os === "osx" ? "Options" : qsTr("Options") + "..."
        hint: qsTr("Change editor settings.")
        onTriggered: {
            root.toolOptions();
            TutorialManager.onActionTriggered("Options", this);
        }
    }
    Action {
        id: gamePlaytest
        text: qsTr("Playtest")
        hint: qsTr("Starts a playtest of the current game.")
        shortcut: "Ctrl+R"
        onTriggered: {
            root.gamePlaytest();
            TutorialManager.onActionTriggered("Playtest", this);
        }
        enabled: projectOpened
    }
    Action {
        id: gameOpenFolder
        text: qsTr("Open Folder")
        hint: qsTr("Opens folder for the current game.")
        onTriggered: {
            root.gameOpenFolder();
            TutorialManager.onActionTriggered("Open Folder", this);
        }
        enabled: projectOpened
    }

    Action {
        id: helpContents
        text: qsTr("Plugin Help Menu")
        hint: qsTr("Open the help.")
        shortcut: "F1"
        onTriggered: {
            root.helpContents();
            TutorialManager.onActionTriggered("Contents", this);
        }
        enabled: true
    }

    // [OneMaker MV] - Added New Menu Actions
    Action {
        id: oneMakerMV_AnimationScreen
        text: qsTr("Open Animation Screen Settings")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_AnimationScreen();
        }
    }

    Action {
        id: oneMakerMV_EventCommandMenu
        text: qsTr("Open Event Command Select Settings")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_EventCommandSelectPage();
        }
    }

    Action {
        id: oneMakerMV_MaxLimitsMenu
        text: qsTr("Open Max Limit Settings")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_MaxLimits()
        }
    }

    Action {
        id: oneMakerMV_ArrayNamesMenu
        text: qsTr("Open Array Names")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_ArrayNames()
        }
    }

    Action {
        id: oneMakerMV_ImageSelectionMenu
        text: qsTr("Open Image Selection")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_ImageSelection()
        }
    }

    Action {
        id: oneMakerMV_WindowMenu
        text: qsTr("Open Window Sizing Settings")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_WindowSizes();
        }
    }

    Action {
        id: oneMakerMV_WorkingModeMenu
        text: qsTr("Open Working Mode Selection")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_WorkingMode()
        }
    }

    Action {
        id: oneMakerMV_ResetSettings
        text: qsTr("Reset Settings Menu")
        hint: qsTr("")
        onTriggered: {
            root.oneMakerMV_ResetSettings()
        }
    }

    Action {
        id: about
        // On OS X, this item will automatically appear in the Application Menu.
        text: Qt.platform.os === "osx" ? "About" : qsTr("About") + "..."
        hint: qsTr("Displays the version number and copyrights.")
        onTriggered: {
            root.about();
            TutorialManager.onActionTriggered("About", this);
        }
        enabled: true
    }

    Action {
        id: tutorial
        text: TutorialManager.running ? qsTr("Stop tutorial") : qsTr("Tutorial...")
        hint: TutorialManager.running ? qsTr("Stop tutorial") : qsTr("Start a tutorial.")
        onTriggered: {
            if(TutorialManager.running){
                TutorialManager.stopTutorial();
                return;
            }
            root.tutorial();
            TutorialManager.onActionTriggered("Tutorial", this);
        }
        enabled: true
    }

    Action {
        id: exit
        // On OS X, this item will automatically appear in the Application Menu.
        text: Qt.platform.os === "osx" ? "Quit" : qsTr("Exit %1").arg(Constants.applicationTitle);
        hint: qsTr("Exits the application.");
        shortcut: StandardKey.Quit
        onTriggered: {
            root.exit();
            TutorialManager.onActionTriggered("Exit", this);
        }
        enabled: true
    }

    onTileScaleChanged: {
        // If tileScale in the Settings was a invalid value, fix it.
        for (var i = 0; i < tileScaleTable.length; i++) {
            if (tileScale <= tileScaleTable[i]) {
                tileScale = tileScaleTable[i];
                break;
            }
        }
    }

    Component.onCompleted: {
        if (TkoolAPI.mvToolsEnabled()) appendToolsRefresh();
        // [OneMaker MV] - Load Default Configuration
        OneMakerMVSettings.loadConfiguration()
    }

    Timer {
        id: appendToolsRefreshTimer
        repeat: true
        running: false
        interval: 1
        onTriggered: {
            if (root.appendToolMenus.length === 0 &&
                    root.appendToolButtons.length === 0) {
                appendToolsRefreshTimer.stop();
                makeAppendToolMenus();
            }
        }
    }

    function appendToolsRefresh() {
        clearAppendMenus();
        appendToolsRefreshTimer.start();

    }

    function clearAppendMenus() {
        var i;
        for (i = 0; i < root.appendToolMenus.length; i++) {
            var menu = root.appendToolMenus[i];
            if (menu.action) menu.action.destroy(1);
            toolMenu.removeItem(menu);
        }
        root.appendToolMenus = [];
        for (i = 0; i < root.appendToolButtons.length; i++) {
            root.appendToolButtons[i].destroy(1);
        }
        root.appendToolButtons = [];
    }

    function makeAppendToolMenus() {
        var appendMenuIndex = findMenuItem(toolMenu, appendMenuItem);
        if (appendMenuIndex > -1 && !!root.appendTools) {
            var tools = JSON.parse(root.appendTools);
            for (var i = 0; i < tools.length; i++) {
                var menuItem = toolMenu.insertItem(appendMenuIndex + 1 + i, tools[i].name);
                root.appendToolMenus.push(menuItem);
                var action = makeAppendToolsAction(tools[i]);
                menuItem.action = action;
                addToolButton(action, tools[i]);
            }
        }
    }

    function findMenuItem(menu, item) {
        for (var i = 0; i < menu.items.length; i++) {
            if (menu.items[i] === item) return i;
        }
        return -1;
    }

    function makeAppendToolsAction(properties) {
        var qmlString = 'import "../BasicControls";' +
                'Action {' +
                'text: "' + properties.name + '";' +
                'hint: "' + properties.hint + '";' +
                'onTriggered: launchTool("' + properties.path + '", "' + properties.appName + '");' +
                'enabled: projectOpened' +
                '}';
        return Qt.createQmlObject(qmlString, root, "action" + properties.name);
    }

    function addToolButton(action, properties) {
        var iconSource = "";
        if (Qt.platform.os === "windows") {
            iconSource = properties.path + "/Identification/toolbar/icon.png";
        } else if (Qt.platform.os === "osx") {
            iconSource = properties.path + "/" + properties.appName + "/Contents/MacOS/Identification/toolbar/icon.png";
        }
        iconSource = "file:/" + iconSource;
        if (!TkoolAPI.isFileExists(iconSource)) {
            iconSource = ImagePack.selectedImagePack + "toolbar/tools_notfound.png"; // [OneMaker MV] - Obtain Image Pack
        }

        var qmlString = 'import "../BasicControls";' +
                'ToolButton{ ' +
                '}';
       var toolButton = Qt.createQmlObject(qmlString, appendToolButtons);
        toolButton.iconSource = iconSource;
        toolButton.action = action;
        root.appendToolButtons.push(toolButton);
    }
}
