.pragma library

var fixedFontLoader;
var normalFontLoader;
var mediumFontLoader;
var heavyFontLoader;
var symbolFontLoader;

var omoriFontLoader; // [OneMaker MV] - OMORI Font

var fixedFontName  = "";
var normalFontName = "";
var mediumFontName = "";
var heavyFontName  = "";
var symbolFontName = "";

var omoriFontName = ""; // [OneMaker MV] - OMORI Font

var previewFontName = "";

var renderType = 0; // Text.QtRendering

function createFontLoader(source) {
    var qml = "import QtQuick 2.3; FontLoader { source: '%1' }".arg(source);
    return Qt.createQmlObject(qml, Qt.application);
}

function createLocaleDetector() {
    var qml = "import QtQuick 2.3; import Tkool.rpg 1.0; QtObject { function locale() { return TkoolAPI.locale() } }";
    return Qt.createQmlObject(qml, Qt.application);
}

function initialize() {
    var locale;

    try {
        locale = createLocaleDetector().locale();
    } catch (e) {
        locale = Qt.locale().name;
        console.warn(e);
    }

    var useMiniFont = (locale.indexOf("zh") === 0) || (locale.indexOf("ko") === 0);

    var fixedFontSource;
    var normalFontSource;
    var mediumFontSource;
    var heavyFontSource;
    var symbolFontSource;

    var omoriFontSource = "../Fonts/OMORI_GAME2.ttf"; // [OneMaker MV] - OMORI Font

    if (useMiniFont) {
        fixedFontSource  = "../Fonts/mplusmini-1m-regular.ttf";
        normalFontSource = "../Fonts/mplusmini-1c-regular.ttf";
        mediumFontSource = "../Fonts/mplusmini-1p-medium.ttf";
        heavyFontSource  = "../Fonts/mplusmini-1p-heavy.ttf";
        symbolFontSource = "../Fonts/mplusmini-1p-heavy.ttf";
    } else {
        fixedFontSource  = "../Fonts/mplus-1m-regular.ttf";
        normalFontSource = "../Fonts/mplus-1c-regular.ttf";
        mediumFontSource = "../Fonts/mplus-1p-medium.ttf";
        heavyFontSource  = "../Fonts/mplus-1p-heavy.ttf";
        symbolFontSource = "../Fonts/mplus-1p-heavy.ttf";
    }

    fixedFontLoader  = createFontLoader(fixedFontSource);
    normalFontLoader = createFontLoader(normalFontSource);
    mediumFontLoader = createFontLoader(mediumFontSource);
    heavyFontLoader  = createFontLoader(heavyFontSource);
    symbolFontLoader = createFontLoader(symbolFontSource);

    omoriFontLoader = createFontLoader(omoriFontSource); // [OneMaker MV] - OMORI Font

    fixedFontName  = fixedFontLoader.name;
    normalFontName = normalFontLoader.name;
    mediumFontName = mediumFontLoader.name;
    heavyFontName  = heavyFontLoader.name;
    symbolFontName = symbolFontLoader.name;

    omoriFontName = omoriFontLoader.name; // [OneMaker MV] - OMORI Font

    // previewFontName should be sync with Window_Base.prototype.standardFontFace in game.
    previewFontName = fixedFontName;

    var localFontName;

    // Traditional Chinese
    if (locale.indexOf("zh") === 0) {
        previewFontName = "SimHei, Heiti TC";

        if (Qt.platform.os == 'windows') {
            localFontName = "Microsoft JhengHei UI, Microsoft JhengHei, PMingLiU, PMingLiU-ExtB, MingLiU, MingLiU-ExtB, sans-serif";
        } else if (Qt.platform.os == 'osx') {
            localFontName = "PingFang TC, Heiti TC, LiHei Pro, STHeiti, sans-serif";
        } else if (Qt.platform.os == 'linux') {
            localFontName = "Source Han Sans TC, Noto Sans CJK TC, WenQuanYi Zen Hei, sans-serif";
        }
    }

    // Simplified Chinese
    if (locale.indexOf("zh_CN") === 0 || locale.indexOf("zh_SG") === 0) {
        previewFontName = "SimHei, Heiti SC";

        if (Qt.platform.os == 'windows') {
            localFontName = "Microsoft Yahei UI, Microsoft Yahei, NSimSun, NSimSun-ExtB, SimSun, SimSun-ExtB, sans-serif";
        } else if (Qt.platform.os == 'osx') {
            localFontName = "PingFang SC, Heiti SC, LiHei Pro, STHeiti, sans-serif";
        } else if (Qt.platform.os == 'linux') {
            localFontName = "Source Han Sans SC, Noto Sans CJK SC, WenQuanYi Zen Hei, sans-serif";
        }
    }

    // Korean
    if (locale.indexOf("ko") === 0) {
        previewFontName = "Dotum, AppleGothic";

        if (Qt.platform.os == 'windows') {
            localFontName = "Malgun Gothic, Gulim, sans-serif";
        } else if (Qt.platform.os == 'osx') {
            localFontName = "Apple SD Gothic Neo, AppleGothic, sans-serif";
        } else if (Qt.platform.os == 'linux') {
            localFontName = "Source Han Sans KR, Noto Sans CJK KR, NanumGothic, UnDotum, Baekmuk Gulim, sans-serif";
        }
    }

    if (localFontName) {
        fixedFontName  += ", " + localFontName;
        normalFontName += ", " + localFontName;
        mediumFontName += ", " + localFontName;
        heavyFontName  += ", " + localFontName;
        symbolFontName += ", " + localFontName;
        previewFontName+= ", " + localFontName;
    }
}

initialize();
