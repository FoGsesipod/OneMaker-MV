import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"
import "../_OneMakerMV"

Canvas {
    id: root

    property string text
    property string faceImageName
    property int faceImageIndex

    property string outlineColor: "rgba(0, 0, 0, 0.5)"
    property int outlineWidth: 4
    property int fontSize: defaultFontSize
    property int iconWidth: 32
    property int iconHeight: 32
    property int fixedHeight: 0
    property int defaultFontSize: 28

    width: 780
    height: 144
    contextType: "2d"

    Palette { id: pal }

    GameImageClip {
        subFolder: "faces"
        imageName: faceImageName
        framePosition: Qt.point(faceImageIndex % 4, Math.floor(faceImageIndex / 4))
        frameSize: Qt.size(sourceSize.width / 4, sourceSize.height / 2)
    }

    Image {
        id: windowskin
        source: DataManager.projectUrl + "img/system/Window.png"
        visible: false
    }

    Image {
        id: iconset
        source: DataManager.projectUrl + "img/system/IconSet.png"
        visible: false
    }

    Canvas {
        id: windowskinCanvas
        width: windowskin.width
        height: windowskin.height
        contextType: "2d"
        visible: false
    }

    onTextChanged: {
        if (fixedHeight === 0) {
            height = calcAllHeight();
        }
    }

    onFixedHeightChanged: {
        if (fixedHeight > 0) {
            height = fixedHeight;
        }
    }

    function calcAllHeight() {
        var textState = {'index': 0};
        textState.text = convertEscapeCharacters(text);
        resetFontSize();
        return calcLineHeight(textState, true);
    }

    onPaint: {
        if (context) {
            context.clearRect(0, 0, width, height);
            context.fillStyle = "white";
            drawTextEx(text, faceImageName.length ? 168 : 0, 0);
        }
    }

    function resetFontSize() {
        fontSize = defaultFontSize;
    }

    function textColor(n) {
        var ctx = windowskinCanvas.context;
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, width, height);
        ctx.drawImage(windowskin, 0, 0);
        var px = 96 + (n % 8) * 12 + 6;
        var py = 144 + Math.floor(n / 8) * 12 + 6;
        var data = ctx.getImageData(px, py, 1, 1).data;
        return rgbToHex(data[0], data[1], data[2]);
    }

    function rgbToHex(r, g, b) {
        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
    }

    function normalColor() {
        return textColor(0);
    }

    function changeTextColor(color) {
        context.fillStyle = color;
    }

    function drawText(text, x, y, lineHeight) {
        var tx = x;
        var ty = y + lineHeight - (lineHeight - fontSize * 0.7) / 2;
        var fontSource =  OneMakerMVSettings.getSetting("workingMode", "expectedContext") ? pal.omoriFont.split(",").map(function(i) { return "'" + i.trim() + "'"; }).join(", ") : pal.previewFont.split(",").map(function(i) { return "'" + i.trim() + "'"; }).join(", "); // [OneMaker MV] - Changed text preview font
        var fontName = fontSource; // [OneMaker MV] - Changed text preview font
        context.font = fontSize + "px " + fontName;
        context.lineWidth = outlineWidth;
        context.lineJoin = 'round';
        context.strokeStyle = outlineColor;
        context.strokeText(text, tx, ty);
        context.fillText(text, tx, ty);
    }

    function drawTextEx(text, x, y) {
        var textState = {'index': 0, 'x': x, 'y': y, 'newX': x};
        textState.text = convertEscapeCharacters(text);
        textState.height = calcLineHeight(textState, false);
        changeTextColor(normalColor());
        resetFontSize();
        while (textState.index < textState.text.length) {
            processCharacter(textState);
        }
    }

    function textWidth(text) {
        var fontSource = OneMakerMVSettings.getSetting("workingMode", "expectedContext") ? pal.omoriFont.split(",").map(function(i) { return "'" + i.trim() + "'"; }).join(", ") : pal.previewFont.split(",").map(function(i) { return "'" + i.trim() + "'"; }).join(", "); // [OneMaker MV] - Changed text preview font
        var fontName = fontSource; // [OneMaker MV] - Changed text preview font
        context.font = fontSize + "px " + fontName;
        return context.measureText(text).width;
    }

    function convertEscapeCharacters(text) {
        text = text.replace(/\\/g, '\x1b');
        text = text.replace(/\x1b\x1b/g, '\\');
        text = text.replace(/\x1bV\[(\d+)\]/gi, function() {
            return 0;
        }.bind(this));
        text = text.replace(/\x1bV\[(\d+)\]/gi, function() {
            return 0;
        }.bind(this));
        text = text.replace(/\x1bN\[(\d+)\]/gi, function() {
            return DataManager.actorName(arguments[1]);
        }.bind(this));
        text = text.replace(/\x1bP\[(\d+)\]/gi, function() {
            return DataManager.actorName(DataManager.system.partyMembers[arguments[1] - 1]);
        }.bind(this));
        text = text.replace(/\x1bG/gi, DataManager.system.currencyUnit);
        return text;
    }

    function processCharacter(textState) {
        switch (textState.text[textState.index]) {
            case '\n':
                processNewLine(textState);
                break;
            case '\f':
                processNewPage(textState);
                break;
            case '\x1b':
                processEscapeCharacter(obtainEscapeCode(textState), textState);
                break;
            default:
                processNormalCharacter(textState);
                break;
        }
    }

    function processNormalCharacter(textState) {
        var c = textState.text[textState.index++];
        var w = textWidth(c);
        drawText(c, textState.x, textState.y, textState.height);
        textState.x += w;
    }

    function processNewLine(textState) {
        textState.x = textState.newX;
        textState.y += textState.height;
        textState.height = calcLineHeight(textState, false);
        textState.index++;
    }

    function processNewPage(textState) {
        textState.index++;
    }

    function obtainEscapeCode(textState) {
        textState.index++;
        var regExp = /^[\$\.\|\^!><\{\}\\]|^[A-Z]+/i;
        var arr = regExp.exec(textState.text.slice(textState.index));
        if (arr) {
            textState.index += arr[0].length;
            return arr[0].toUpperCase();
        } else {
            return '';
        }
    }

    function obtainEscapeParam(textState) {
        var arr = /^\[\d+\]/.exec(textState.text.slice(textState.index));
        if (arr) {
            textState.index += arr[0].length;
            return parseInt(arr[0].slice(1));
        } else {
            return '';
        }
    }

    function processEscapeCharacter(code, textState) {
        switch (code) {
            case 'C':
                changeTextColor(textColor(obtainEscapeParam(textState)));
                break;
            case 'I':
                processDrawIcon(obtainEscapeParam(textState), textState);
                break;
            case '{':
                makeFontBigger();
                break;
            case '}':
                makeFontSmaller();
                break;
        }
    }

    function processDrawIcon(iconIndex, textState) {
        drawIcon(iconIndex, textState.x + 2, textState.y + 2);
        textState.x += iconWidth + 4;
    }

    function makeFontBigger() {
        if (fontSize <= 96)
            fontSize += 12;
    }

    function makeFontSmaller() {
        if (fontSize >= 24)
            fontSize -= 12;
    }

    function calcLineHeight(textState, all) {
        var lastFontSize = fontSize;
        var lineHeight = 0;
        var lines = textState.text.slice(textState.index).split('\n');
        var maxLines = all ? lines.length : 1;

        for (var i = 0; i < maxLines; i++) {
            var maxFontSize = fontSize;
            var regExp = /\x1b[\{\}]/g;
            for (; ; ) {
                var arr = regExp.exec(lines[i]);
                if (arr) {
                    if (arr[0] === '\x1b{')
                        makeFontBigger();
                    if (arr[0] === '\x1b}')
                        makeFontSmaller();
                    maxFontSize = Math.max(maxFontSize, fontSize);
                } else {
                    break;
                }
            }
            lineHeight += maxFontSize + 8;
        }

        fontSize = lastFontSize;
        return lineHeight;
    }

    function drawIcon(iconIndex, x, y) {
        var sx = iconIndex % 16 * iconWidth;
        var sy = Math.floor(iconIndex / 16) * iconHeight;
        context.drawImage(iconset, sx, sy, iconWidth, iconHeight, x, y, iconWidth, iconHeight);
    }
}
