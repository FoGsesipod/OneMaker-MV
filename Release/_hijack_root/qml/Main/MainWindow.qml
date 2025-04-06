import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtWebEngine 1.0
import Qt.labs.settings 1.0
//import QtWebView 1.0 [OneMaker MV] - Synchronize steam and non-steam versions
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

ApplicationWindow {
    id: root

    readonly property string gameTitle: DataManager.gameTitle

    // [OneMaker MV] - Add PluginHelpEverywhere to replace default help action
    property var dialogPluginHelp: Dialog_PluginHelpEverywhere { }

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

    // [OneMaker MV] - Synchronize steam and non-steam versions
    //property string getLatestPostUrl: "http://13.115.163.66/wp-json/myplugin/v1/latest_post_by_product_and_language/?product=mv&language="
    //property string noticeLocale: ""
    //property var webViewWindow: null


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

        // [OneMaker MV] - Added Menu Items
        onOneMakerMV_AnimationScreen: openAnimationScreen()
        onOneMakerMV_EventCommandSelectPage: openEventCommandSelectPage()
        onOneMakerMV_MaxLimits: openMaxLimits()
        onOneMakerMV_ArrayNames: openArrayNames()
        onOneMakerMV_ImageSelection: openImageSelection()
        onOneMakerMV_WindowSizes: openWindowSizes()
        onOneMakerMV_WorkingMode: openWorkingMode()
        onOneMakerMV_ResetSettings: openResetSettings()

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
    // [OneMaker MV] - Load Menus
    OneMakerMV_AnimationScreen {
        id: one_AnimationScreen
    }
    OneMakerMV_EventCommandSelectPage {
        id: one_EventCommandSelectPage
    }
    OneMakerMV_MaxLimits {
        id: one_MaxLimits
    }
    OneMakerMV_ArrayNames {
        id: one_ArrayNames
    }
    OneMakerMV_ImageSelection {
        id: one_ImageSelection
    }
    OneMakerMV_WindowSizes {
        id: one_WindowSizes
    }
    OneMakerMV_WorkingMode {
        id: one_WorkingMode
    }
    OneMakerMV_ResetSettings {
        id: one_ResetSettings
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
        //options.requestOpenWebViewWindow.connect(root.openWebViewWindow) [OneMaker MV] - Synchronize steam and non-steam versions
        adjustWindow();
        //checkServerHealth(); [OneMaker MV] - Synchronize steam and non-steam versions
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
        dialogPluginHelp.open()
    }

    // [OneMaker MV] - Open Menu Functions
    function openAnimationScreen() {
        heavy.run(function() {
            one_AnimationScreen.open();
        })
    }

    function openEventCommandSelectPage() {
        heavy.run(function() {
            one_EventCommandSelectPage.open();
        })
    }

    function openMaxLimits() {
        heavy.run(function() {
            one_MaxLimits.open();
        })
    }

    function openArrayNames() {
        heavy.run(function() {
            one_ArrayNames.open()
        })
    }

    function openImageSelection() {
        heavy.run(function() {
            one_ImageSelection.open()
        })
    }

    function openWindowSizes() {
        heavy.run(function() {
            one_WindowSizes.open();
        });
    }

    function openWorkingMode() {
        heavy.run(function() {
            one_WorkingMode.open()
        })
    }

    function openResetSettings() {
        heavy.run(function() {
            one_ResetSettings.open()
        })
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
// [OneMaker MV] - Synchronize steam and non-steam versions
//
//    // WebEngineViewのインスタンスを作成し、表示する関数
//    function openWebViewWindow() {
//        if (webViewWindow == null) {
//            var component = Qt.createComponent("../Options/NoticeWebView.qml");
//            if (component.status === Component.Ready) {
//                webViewWindow = component.createObject(root);
//            } else {
//                // エラーハンドリング
//                console.log("Error:", component.errorString());
//            }
//        }
//
//        if (webViewWindow != null) {
//            webViewWindow.open();
//            webViewWindow.raise();
//        }
//    }
//
//
//    function checkServerHealth() {
//          var xhr = new XMLHttpRequest();
//
//          var locale = TkoolAPI.locale();
//          if (locale === "ja_JP"){
//              SettingsManager.storage.noticeLocale = "ja";
//          } else  if (locale === "zh_CN"){
//              SettingsManager.storage.noticeLocale = "zh";
//          } else {
//              SettingsManager.storage.noticeLocale = "en";
//          }
//
//          xhr.onreadystatechange = function() {
//              if (xhr.readyState === XMLHttpRequest.DONE) {
//                  if (xhr.status === 200||xhr.status === 0) {
//                      console.log(xhr.responseText)
//                      var data = JSON.parse(xhr.responseText);
//                      if (data && data.date) {
//                          SettingsManager.storage.noticeToppageUrl = data.toppage;
//                          console.log(data.toppage)
//                          if (isNewNotice(data)) {
//                              SettingsManager.storage.latestNoticeDate = data.date;
//                               openWebViewWindow()
//                          }
//                      }
//                  }
//              }
//          }
//          xhr.open("GET", getLatestPostUrl + SettingsManager.storage.noticeLocale);
//          xhr.send();
//      }
//
//
//
//      function isNewNotice(data) {
//          if (!SettingsManager.storage.latestNoticeDate) {
//              return true;
//          }
//
//          var latestDate = new Date(SettingsManager.storage.latestNoticeDate);
//          var newDate = new Date(data.date);
//
//          return newDate > latestDate;
//      }
}
