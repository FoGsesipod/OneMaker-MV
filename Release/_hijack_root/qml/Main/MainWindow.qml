import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtWebEngine 1.0
import Qt.labs.settings 1.0
import QtWebView 1.0
import Tkool.rpg 1.0
import "../BasicControls"
import "../Controls"
import "../Dialogs"
import "../Database"
import "../Options"
import "../Plugin"
import "../Singletons"
import "../BasicControls/FontManager.js" as FontManager
import "../CharacterGenerator"
import "../_OneMakerMV"

ApplicationWindow {
    id: root

    readonly property string gameTitle: DataManager.gameTitle

    property bool qmlTextWorkaround: {
        // [Workaround] QML Text has a problem with Intel on-board graphics.
        // (QTBUG-44256)
        if (TkoolAPI.isBlackListedDisplayDevice()) {
            FontManager.renderType = Text.NativeRendering;
            PaletteSingleton.updateRenderType();
            return true;
        }
        return false;
    }

    property string getLatestPostUrl: "http://13.115.163.66/wp-json/myplugin/v1/latest_post_by_product_and_language/?product=mv&language="
    property string noticeLocale: ""
    property var webViewWindow: null


    title: (gameTitle ? gameTitle + " - " : "") + Constants.applicationTitle
    width: 1200
    height: 720
    minimumWidth: 900
    minimumHeight: 600

    visible: true

    menuBar: mainMenu.menuBar
    toolBar: mainMenu.toolBar
    statusBar: client.statusbar

    property bool terminating: false
    property Item mainMenu: mainMenu

    Settings {
        property alias windowX: root.x
        property alias windowY: root.y
        property alias windowWidth: root.width
        property alias windowHeight: root.height
    }

    WindowThemeObserver {
        targetWindow: root
    }

    ProjectManager {
        id: projectManager
        mainMenu: mainMenu

        onProjectFileUrlChanged: {
            TkoolAPI.setWindowRepresentedFilename(root, TkoolAPI.urlToPath(projectManager.projectFileUrl));
        }
    }

    MainMenu {
        id: mainMenu
        onToolDatabase: openDatabase()
        onToolPluginManager: openPluginManager()
        onToolSoundTest: openSoundTest()
        onToolEventSearcher: openEventSearcher()
        onToolCharacterGenerator: openCharacterGenerator()
        onToolResourceManager: openResourceManager()
        onToolAppendTools: openAppendManager()
        onToolOptions: openOptions()
        onGamePlaytest: startPlaytest()
        onGameOpenFolder: openGameFolder()
        onAbout: aboutBox.open()
        onExit: root.close()
        onHelpContents: openHelp()
        onSteamWindow: openSteamWindow()
        onTutorial: openTutorial()
        onLaunchTool: launch(path, appName)
    }

    MainWindowClient {
        id: client
        mainMenu: mainMenu
        editMode: mainMenu.editMode
        drawingTool: mainMenu.drawingTool
        tileScale: mainMenu.tileScale
        DropArea {
            anchors.fill: parent
            onDropped: {
                if (drop.urls.length === 1) {
                    var path = drop.urls[0].toString();
                    var dotPos = path.lastIndexOf(".");
                    var ext = dotPos > 0 ? path.slice(dotPos + 1) : "";
                    if (ext === Constants.projectExtName) {
                        projectManager.doOpen(path);
                        drop.accept();
                    }
                }
            }
        }
    }

    WebEngineView {
        id: webEngine
        Component.onCompleted: {
            AudioPlayer.setWebEngine(webEngine);
        }
    }

    DatabaseMain {
        id: database
        onClose: client.reloadTileset()
    }
    Dialog_PluginManager {
        id: pluginManager
    }
    Dialog_SoundTest {
        id: soundTest
    }
    Dialog_EventSearcher {
        id: eventSearcher
    }
    Dialog_CharacterGenerator {
        id: characterGenerator
    }
    Dialog_ResourceManager {
        id: resourceManager
    }
    Dialog_AppendTools {
        id: appendManager
        onOk: mainMenu.appendToolsRefresh()
        onCancel: mainMenu.appendToolsRefresh()
    }
    Dialog_Options {
        id: options
    }
    Dialog_GamePlayer {
        id: gamePlayer
    }
    Dialog_About {
        id: aboutBox
    }
    Dialog_TutorialSelector {
        id: tutorialSelector
    }

    Loader {
        id: steamLoader
        property bool valid : item !== null
        source: "SteamWindow.qml"
    }

    HeavyProcessTimer {
        id: heavy
    }

    Timer {
        id: toolLauncher
        interval: 1

        property string path;

        function launch(path) {
            toolLauncher.path = path;
            start();
        }

        onTriggered: {
            var command = "\"" + path + "\"";
            var args = TkoolAPI.urlToPath(projectManager.projectFileUrl);

            if (Qt.platform.os === "windows") command += " " + args;
            else if (Qt.platform.os === "osx") command = "open " + command + " --args " + args;
            else  command += " " + args;
            TkoolAPI.launch(command);
        }
    }

    Timer {
        // [Workaround] Could be crash on Windows when calling
        // Qt.openUrlExternally() directly from action handlers.

        id: urlOpener
        interval: 1

        property url url;

        function open(url) {
            urlOpener.url = url;
            start();
        }

        onTriggered: {
           Qt.openUrlExternally(url);
        }
    }

    Component.onCompleted: {
        options.requestOpenWebViewWindow.connect(root.openWebViewWindow)
        adjustWindow();
        checkServerHealth();
    }

    onClosing: {
        if (!terminating) {
            projectManager.confirmSave(function() {
                terminating = true;
                if (TkoolAPI.isSteamRelease() && steamLoader.item) {
                    steamLoader.item.shutdown();
                }
                root.close();
            });
            close.accepted = false;
        }
    }

    onVisibleChanged: {
        if (!visible) {
            Qt.quit();
        }
    }

    function adjustWindow() {
        // QML does not provide a way to access QScreen::availableGeometry.
        var minX = TkoolAPI.desktopX();
        var minY = TkoolAPI.desktopY();
        var maxWidth = TkoolAPI.desktopWidth();
        var maxHeight = TkoolAPI.desktopHeight();
        var maxX = minX + maxWidth;
        var maxY = minY + maxHeight;
        if (width >= maxWidth) {
            width = maxWidth;
        }
        if (height >= maxHeight) {
            height = maxHeight;
        }
        if (x >= maxX - width) {
            x = maxX - width;
        }
        if (y >= maxY - height) {
            y = maxY - height;
        }
        if (x < minX) {
            x = minX;
        }
        if (y < minX) {
            y = minX;
        }
    }

    function startPlaytest() {
        projectManager.confirmSave(function() {
            gamePlayer.open();
        });
    }

    function openDatabase() {
        heavy.run(function() {
            database.open();
        });
    }

    function openPluginManager() {
        heavy.run(function() {
            pluginManager.open();
        });
    }

    function openSoundTest() {
        heavy.run(function() {
            soundTest.open();
        });
    }

    function openEventSearcher() {
        heavy.run(function() {
            eventSearcher.open();
        });
    }

    function openCharacterGenerator() {
        heavy.run(function() {
            characterGenerator.open();
        });
    }

    function openResourceManager() {
        heavy.run(function() {
            resourceManager.open();
        });
    }

    function openAppendManager() {
        heavy.run(function() {
            appendManager.open();
        });
    }

    function launch(path, appName) {
        path = path + TkoolAPI.directorySeparator() + appName;
        if (!TkoolAPI.isFileExists(TkoolAPI.pathToUrl(path))) {
            projectManager.launchError(path);
        }
        else {
            toolLauncher.launch(path);
        }
    }


    function openOptions() {
        heavy.run(function() {
            options.open();
        });
    }

    function openGameFolder() {
        urlOpener.open(DataManager.projectUrl);
    }

    function openHelp() {
        var helpPath = TkoolAPI.applicationDirPath() + "/Help/index.html";
        var helpUrl = TkoolAPI.pathToUrl(helpPath);
        urlOpener.open(helpUrl);
    }

    function openSteamWindow() {
        heavy.run(function() {
            if (TkoolAPI.isSteamRelease() && steamLoader.item) {
                steamLoader.item.mainWindow = root;
                steamLoader.item.projectManager = projectManager;

                steamLoader.item.showNormal();
            }
        });
    }

    function openTutorial() {
        heavy.run(function() {
            tutorialSelector.open();
        });
    }


    // WebEngineViewのインスタンスを作成し、表示する関数
    function openWebViewWindow() {
        if (webViewWindow == null) {
            var component = Qt.createComponent("../Options/NoticeWebView.qml");
            if (component.status === Component.Ready) {
                webViewWindow = component.createObject(root);
            } else {
                // エラーハンドリング
                console.log("Error:", component.errorString());
            }
        }

        if (webViewWindow != null) {
            webViewWindow.open();
            webViewWindow.raise();
        }
    }


    function checkServerHealth() {
        Logger.initialize() // [OneMaker MV] - Added Logger initializaton
          var xhr = new XMLHttpRequest();

          var locale = TkoolAPI.locale();
          if (locale === "ja_JP"){
              SettingsManager.storage.noticeLocale = "ja";
          } else  if (locale === "zh_CN"){
              SettingsManager.storage.noticeLocale = "zh";
          } else {
              SettingsManager.storage.noticeLocale = "en";
          }

          xhr.onreadystatechange = function() {
              if (xhr.readyState === XMLHttpRequest.DONE) {
                  if (xhr.status === 200||xhr.status === 0) {
                      console.log(xhr.responseText)
                      var data = JSON.parse(xhr.responseText);
                      if (data && data.date) {
                          SettingsManager.storage.noticeToppageUrl = data.toppage;
                          console.log(data.toppage)
                          if (isNewNotice(data)) {
                              SettingsManager.storage.latestNoticeDate = data.date;
                               openWebViewWindow()
                          }
                      }
                  }
              }
          }
          xhr.open("GET", getLatestPostUrl + SettingsManager.storage.noticeLocale);
          xhr.send();
      }



      function isNewNotice(data) {
          if (!SettingsManager.storage.latestNoticeDate) {
              return true;
          }

          var latestDate = new Date(SettingsManager.storage.latestNoticeDate);
          var newDate = new Date(data.date);

          return newDate > latestDate;
      }
}
