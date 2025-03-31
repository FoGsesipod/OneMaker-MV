import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"
import "../_OneMakerMV"
import "../Scripts/JsonTemplates.js" as JsonTemplates

Item {
    id: root

    property Item mainMenu: null
    property Item gameShareDialog: null
    property Item gameShareDialogOgc: null
    property Item monacaDialog: null

    property string projectFileUrl: ""

    Settings {
        property alias projectFileUrl: root.projectFileUrl
    }

    Connections {
        target: mainMenu
        onFileNew: root.fileNew()
        onFileOpen: root.fileOpen()
        onFileSave: root.fileSave()
        onFileClose: root.fileClose()
        onFileDeployment: root.fileDeployment()
        onGameShare: root.gameShare();
        onMonacaUpload: root.monacaUpload();
    }

    HeavyProcessTimer {
        id: heavy
    }

    Dialog_NewProject {
        id: newProjectDialog
        onOk: {
            clear();
            copyingDialog.open();
        }
    }

    Dialog_Copying {
        id: copyingDialog
        folderName: newProjectDialog.folderName
        gameTitle: newProjectDialog.gameTitle
        location: newProjectDialog.location
        onOk: {
            privateObj.createProject(folderName, gameTitle, location);
        }
        onCancel: {
            root.clear();
        }
        onError: {
            root.error(qsTr("Failed to create a new project."));
        }
    }

    Dialog_Deployment {
        id: deploymentDialog
        projectFileUrl: root.projectFileUrl
        onOk: {
            confirmOverwrite(function() {
                packagingDialog.open();
            });
        }
    }

    Dialog_Packaging {
        id: packagingDialog
        projectFileUrl: root.projectFileUrl
        packageUrl: deploymentDialog.packageUrl
        platform: deploymentDialog.platform
        assetStrip: deploymentDialog.assetStrip
        encryptionKey: deploymentDialog.encryptionKey
        isEncryptedImage: deploymentDialog.isEncryptedImage
        isEncryptedAudio: deploymentDialog.isEncryptedAudio
        zipCompression: deploymentDialog.zipCompression
        onOk: {
            successBox.message = qsTr("Succeeded to create a distribution package.");
            successBox.open();
        }
        onError: {
            root.error(qsTr("Failed to create a distribution package."));
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Open Project")
        folder: TkoolAPI.pathToUrl(TkoolAPI.standardDocumentsLocation())
        nameFilters: [ Constants.projectFilter ]
        onAccepted: {
            TutorialManager.onOkDialog("FileDialog", fileDialog);
            doOpen(String(fileUrl));
        }
        onRejected: {
            TutorialManager.onCancelDialog("FileDialog", fileDialog);
        }
    }

    Timer {
        // Report FileDialog visibility(open/close) to TutorialManager.

        interval: 100
        running: true
        repeat: true
        property bool fileDialogVisible: false

        onTriggered: {
            if(fileDialog.visible){
                if(!fileDialogVisible){
                    fileDialogVisible = true;
                    TutorialManager.onOpenDialog("FileDialog", fileDialog);
                }
            } else {
                if(fileDialogVisible){
                    fileDialogVisible = false;
                    TutorialManager.onCloseDialog("FileDialog", fileDialog);
                }
            }
        }
    }

    MessageBox {
        id: saveConfirmBox
        iconType: "question"
        useYesNo: true
        useCancel: true
        message: qsTr("Save changes to the game?");

        property var callback

        resources: Timer {
            id: callbackTimer1
            interval: 1
            onTriggered: saveConfirmBox.callback()
        }

        onYes: {
            heavy.run(function() {
                if (privateObj.saveProject() && callback) {
                    callbackTimer1.start();
                }
            });
        }

        onNo: {
            if (callback) {
                callbackTimer1.start();
            }
        }
    }

    MessageBox {
        id: overwriteConfirmBox
        iconType: "question"
        useYesNo: true
        message: qsTr("The output folder already exists. Overwrite?");

        property var callback

        resources: Timer {
            id: callbackTimer2
            interval: 1
            onTriggered: overwriteConfirmBox.callback()
        }

        onYes: {
            if (callback) {
                callbackTimer2.start();
            }
        }
    }

    MessageBox {
        id: successBox
        iconType: "check"
    }

    MessageBoxWithUrl {
        id: successUploadBox
        iconType: "check"
    }

    MessageBox {
        id: errorBox
        iconType: "warning"
    }

    MessageBox {
        id: launchErrorBox
        iconType: "warning"
    }

    signal fileNew()
    signal fileOpen()
    signal fileSave()
    signal fileClose()
    signal fileDeployment()
    signal gameShare()
    signal gameShareOgc()
    signal monacaUpload()

    signal confirmSave(var callback)
    signal confirmOverwrite(var callback)

    signal load()
    signal error(var message)
    signal launchError(var path)

    onFileNew: {
        confirmSave(function() {
            newProjectDialog.open();
        });
    }

    onFileOpen: {
        heavy.run(function() {
            fileDialog.open();
        });
    }

    onFileSave: {
        heavy.run(function() {
            privateObj.saveProject();
        });
    }

    onFileClose: {
        confirmSave(function() {
            clear();
        });
    }

    onFileDeployment: {
        confirmSave(function() {
            deploymentDialog.open();
        });
    }

    onGameShare: {
        confirmSave(function() {
            root.gameShareDialog.open();
        });
    }

    onGameShareOgc: {
        confirmSave(function() {
            root.gameShareDialogOgc.open();
        });
    }

    onMonacaUpload: {
        confirmSave(function() {
            root.monacaDialog.open();
        });
    }

    onConfirmSave: {
        if (DataManager.isAnyModified() && DataManager.projectOpened) {
            saveConfirmBox.callback = callback;
            saveConfirmBox.open();
        } else if (callback) {
            callback();
        }
    }

    onConfirmOverwrite: {
        if (TkoolAPI.isDirectoryExists(deploymentDialog.packageUrl)) {
            overwriteConfirmBox.callback = callback;
            overwriteConfirmBox.open();
        } else if (callback) {
            callback();
        }
    }

    function clear() {
        projectFileUrl = "";
        DataManager.projectUrl = "";
        DataManager.gameTitle = "";
        DataManager.projectOpened = false;
        TkoolAPI.collectGarbage();
        TkoolAPI.clearImageCache();
    }

    function doOpen(url) {
        heavy.run(function() {
            privateObj.openProject(url, false)
        });
    }

    Component.onCompleted: {
        if (projectFileUrl) {
            heavy.run(function() {
                privateObj.openProject(projectFileUrl, true);
            });
        }

        var qmlString = "";

        if (TkoolAPI.isAllowUpload() & TkoolAPI.Atsumaal) {
            qmlString = 'import "../GameShare";' +
                            'GameShare { ' +
                            'id: gameShare; ' +
                            'projectManager: root; ' +
                            'messageBox: successUploadBox; ' +
                            'projectFileUrl: root.projectFileUrl; ' +
                            '}';
            root.gameShareDialog = Qt.createQmlObject(qmlString, root, "GameShare");
        }
        if (TkoolAPI.isAllowUpload() & TkoolAPI.OpenGameCreators) {
            qmlString = 'import "../GameShareOgc";' +
                            'GameShareOgc { ' +
                            'id: gameShareOgc; ' +
                            'projectManager: root; ' +
                            'messageBox: successUploadBox; ' +
                            'projectFileUrl: root.projectFileUrl; ' +
                            '}';
            root.gameShareDialogOgc = Qt.createQmlObject(qmlString, root, "GameShareOgc");
        }
        if (TkoolAPI.isAllowUpload() & TkoolAPI.Monaca) {
            qmlString = 'import "../GameShare";' +
                            'Monaca { ' +
                            'id: monaca; ' +
                            'projectManager: root; ' +
                            'messageBox: successBox; ' +
                            'messageBox2: successUploadBox; ' +
                            'projectFileUrl: root.projectFileUrl; ' +
                            '}';
            root.monacaDialog = Qt.createQmlObject(qmlString, root, "Monaca");
        }
    }

    onLoad: {
        OneMakerMVSettings.findCorePlugin()
        DataManager.updateGameTitle();
        DataManager.currentMapId = DataManager.getSystemValue("editMapId", 0);
        DataManager.projectOpened = false;
        DataManager.projectOpened = true;
        TkoolAPI.collectGarbage();
        TkoolAPI.clearImageCache();
    }

    onError: {
        if (!errorBox.windowVisible) {
            errorBox.message = message;
            errorBox.open();
        }
    }

    onLaunchError: {
        if (!launchErrorBox.windowVisible) {
            var message = qsTr("The tool could not be launched.") + "\n" + path;
            launchErrorBox.message = message;
            launchErrorBox.open();
        }
    }

    NewDataMaker {
        id: newDataMaker
    }

    QtObject {
        id: privateObj

        property var directoryList: [
            "data",
            "fonts",
            "audio/bgm",
            "audio/bgs",
            "audio/me",
            "audio/se",
            "img/animations",
            "img/battlebacks1",
            "img/battlebacks2",
            "img/characters",
            "img/enemies",
            "img/faces",
            "img/parallaxes",
            "img/pictures",
            "img/sv_actors",
            "img/sv_enemies",
            "img/system",
            "img/tilesets",
            "img/titles1",
            "img/titles2",
            "js/libs",
            "js/plugins",
            "movies"
        ]

        function createProject(folderName, gameTitle, location) {
            var projectFileUrl = makeProjectFileUrl(folderName, location);

            if (!writeProjectFile(projectFileUrl)) {
                return false;
            }
            if (!openProject(projectFileUrl, false)) {
                return false;
            }

            try {
                newDataMaker.make();
            } catch (e) {
                error(qsTr("Failed to write database."));
                root.clear();
                return false;
            }

            DataManager.setSystemValue("gameTitle", gameTitle);
            DataManager.updateGameTitle();
            if(!saveProject()) return false;
            // if TutorialManager copied preset data, then the project is reloaded.
            if(TutorialManager.isPresetDataSet(projectFileUrl)){
                root.clear();
                if(!openProject(projectFileUrl, true)){
                    return false;
                }
                DataManager.setSystemValue("gameTitle", gameTitle);
                DataManager.updateGameTitle();
                if(!saveProject()) return false;
            }
            return true;
        }

        function makeProjectFileUrl(folderName, location) {
            var projectFileUrl = TkoolAPI.pathToUrl(location);

            if (!projectFileUrl.toString().match(/\/$/)) {
                projectFileUrl += "/";
            }
            projectFileUrl += folderName;
            projectFileUrl += "/" + Constants.projectFileName;

            return projectFileUrl;
        }

        function openProject(projectFileUrl, silent) {
            var data = TkoolAPI.readFile(projectFileUrl);
            if (data) {
                if (checkVersion(data)) {
                    root.clear();
                    updateProjectPath(projectFileUrl);
                    if (DataManager.loadDatabase()) {
                        if (DataManager.loadPlugins()) {
                            root.load();
                            TutorialManager.onActionTriggered("Project Loaded", this);
                            return true;
                        } else {
                            error(qsTr("Unable to read file %1.").arg('plugins.js'));
                            root.clear();
                            return false;
                        }
                    } else {
                        error(qsTr("Unable to read file %1.").arg(DataManager.errorFileName));
                        root.clear();
                        return false;
                    }
                }
            } else {
                if (!silent) {
                    var name = extractFileName(projectFileUrl);
                    error(qsTr("Unable to read file %1.").arg(name));
                }
                root.clear();
                return false;
            }
        }

        function saveProject() {
            if (!writeProjectFile(root.projectFileUrl)) {
                return false;
            }
            if (!createAllDirectories()) {
                return false;
            }

            DataManager.setSystemValue("editMapId", DataManager.currentMapId);
            DataManager.setSystemValue("versionId", Math.floor(Math.random() * 100000000));

            if (!DataManager.saveAll()) {
                error(qsTr("Unable to write file %1.").arg(DataManager.errorFileName));
                return false;
            }
            if (!rewriteHtml()) {
                error(qsTr("Unable to write file %1.").arg("index.html"));
                return false;
            }

            return true;
        }

        function rewriteHtml() {
            var url = DataManager.projectUrl + "index.html";
            var data = TkoolAPI.readFile(url);
            if (data) {
                var title = "<title>" + escapeHtml(DataManager.gameTitle) + "</title>";
                data = data.replace(/\<title\>[^\<]*\<\/title\>/, title);
                return TkoolAPI.writeFile(url, data);
            }
            return true;
        }

        function escapeHtml(s) {
            s = s.replace(/&/g,'&amp;');
            s = s.replace(/>/g,'&gt;');
            s = s.replace(/</g,'&lt;');
            return s;
        }

        function extractDirName(path) {
            return path.slice(0, path.lastIndexOf("/") + 1);
        }

        function extractFileName(path) {
            return path.slice(path.lastIndexOf("/") + 1);
        }

        function checkVersion(text) {
            var majorVersion = parseInt(Qt.application.version);
            var info = text.split(/\s/, 2);
            if (info[0] !== Qt.application.name) {
                error(qsTr("Unexpected file format."));
                return false;
            }
            if (parseInt(info[1]) > majorVersion) {
                error(qsTr("Version error."));
                return false;
            }
            return true;
        }

        function updateProjectPath(projectFileUrl) {
            root.projectFileUrl = projectFileUrl;
            DataManager.projectUrl = extractDirName(projectFileUrl);
            fileDialog.folder = DataManager.projectUrl;
            AudioPlayer.setFolder(DataManager.projectUrl);
        }

        function writeProjectFile(projectFileUrl) {
            if (!TkoolAPI.writeFile(projectFileUrl, createProjectFileContent())) {
                var name = extractFileName(projectFileUrl);
                error(qsTr("Unable to write file %1.").arg(name));
                return false;
            }
            return true;
        }

        function createAllDirectories() {
            for (var i = 0; i < directoryList.length; i++) {
                var directory = directoryList[i];
                var url = DataManager.projectUrl + directory;
                if (!TkoolAPI.isDirectoryExists(url) && !TkoolAPI.createDirectories(url)) {
                    error(qsTr("Unable to create directory %1.").arg(directory));
                    return false;
                }
            }
            return true;
        }

        function createProjectFileContent() {
            return Qt.application.name + " " + Qt.application.version;
        }
    }
}
