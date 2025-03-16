import QtQuick 2.3
import "FontManager.js" as FontManager
import "."

QtObject {
    readonly property string fixedFont:      FontManager.fixedFontName
    readonly property string normalFont:     FontManager.normalFontName
    readonly property string mediumFont:     FontManager.mediumFontName
    readonly property string heavyFont:      FontManager.heavyFontName
    readonly property string symbolFont:     FontManager.symbolFontName
    readonly property string previewFont:    FontManager.previewFontName

    readonly property string omoriFont:      FontManager.omoriFontName // [OneMaker MV] - Identifier for OMORI font

    readonly property int renderType:        __renderType
    property int __renderType:               FontManager.renderType

    readonly property int fontSize:          14
    readonly property int labelFontSize:     13
    readonly property int controlHeight:     27

    readonly property var data:              ThemeManager.currentTheme

    readonly property color window1:         data.window1
    readonly property color window2:         data.window2
    readonly property color outsideArea:     data.outsideArea
    readonly property color inactiveTab1:    data.inactiveTab1
    readonly property color inactiveTab2:    data.inactiveTab2
    readonly property color controlFrame:    data.controlFrame
    readonly property color toolBar1:        data.toolBar1
    readonly property color toolBar2:        data.toolBar2
    readonly property color scrollBar1:      data.scrollBar1
    readonly property color scrollBar2:      data.scrollBar2
    readonly property color focusFrame:      data.focusFrame

    readonly property color normalText:      data.normalText
    readonly property color normalBack1:     data.normalBack1
    readonly property color normalBack2:     data.normalBack2
    readonly property color selectedText:    data.selectedText
    readonly property color selectedBack:    data.selectedBack
    readonly property color selectedEdText:  data.selectedEdText
    readonly property color selectedEdBack:  data.selectedEdBack
    readonly property color disabledText:    data.disabledText
    readonly property real  disabledOpacity: data.disabledOpacity
    readonly property color hyperLinkText:   data.hyperLinkText

    readonly property color button1:         data.button1
    readonly property color button2:         data.button2
    readonly property color buttonFrame:     data.buttonFrame
    readonly property color pressedButton1:  data.pressedButton1
    readonly property color pressedButton2:  data.pressedButton2
    readonly property color pressedButtonText:data.pressedButtonText
    readonly property color hotButton1:      data.hotButton1
    readonly property color hotButton2:      data.hotButton2
    readonly property color hotButtonText:   data.hotButtonText
    readonly property color twinklingBtn1:   data.twinklingBtn1
    readonly property color twinklingBtn2:   data.twinklingBtn2
    readonly property color groupBox1:       data.groupBox1
    readonly property color groupBox2:       data.groupBox2
    readonly property color groupBoxFrame:   data.groupBoxFrame
    readonly property color deluxeLabel1:    data.deluxeLabel1
    readonly property color deluxeLabel2:    data.deluxeLabel2
    readonly property color deluxeLabelText: data.deluxeLabelText

    readonly property color highlight:       data.highlight
    readonly property color workArea:        data.workArea
    readonly property color checkMark:       data.checkMark
    readonly property color dropTarget:      data.dropTarget
    readonly property color progressBar:     data.progressBar

    readonly property string arrowLeftImage: data.arrowLeftImage
    readonly property string arrowRightImage:data.arrowRightImage
    readonly property string arrowUpImage:   data.arrowUpImage
    readonly property string arrowDownImage: data.arrowDownImage

    Component.onCompleted: {
        updateRenderType();
    }

    function updateRenderType() {
        __renderType = FontManager.renderType;
    }
}
