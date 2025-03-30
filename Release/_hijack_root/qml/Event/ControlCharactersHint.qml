import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"

Column {
    id: root

    property bool full: false

    readonly property string title: qsTr("Control characters")

    readonly property var texts1: [
        "\\V[n]", qsTr("Replaced by the value of the nth variable."),
        "\\SV[n]", qsTr("Replaced by the value of the nth self variable."), // [OneMaker MV] - Added \SV[n]
        "\\N[n]", qsTr("Replaced by the name of the nth actor."),
        "\\P[n]", qsTr("Replaced by the name of the nth party member."),
        "\\G",    qsTr("Replaced by the currency unit."),
        "\\C[n]", qsTr("Draw the subsequent text in the nth color."),
        "\\I[n]", qsTr("Draw the nth icon."),
        "\\{",    qsTr("Increase the text size by one step."),
        "\\}",    qsTr("Decrease the text size by one step."),
        "\\\\",   qsTr("Replaced with the backslash character.")
    ]
    readonly property var texts2: [
        "\\$",    qsTr("Open the gold window."),
        "\\.",    qsTr("Wait 1/4 second."),
        "\\|",    qsTr("Wait 1 second."),
        "\\!",    qsTr("Wait for button input."),
        "\\>",    qsTr("Display remaining text on same line all at once."),
        "\\<",    qsTr("Cancel the effect that displays text all at once."),
        "\\^",    qsTr("Do not wait for input after displaying text.")
    ]

    Palette { id: pal }
    Text {
        text: title + ":"
        font.family: pal.normalFont
        font.pixelSize: pal.fontSize - 1
    }
    Repeater {
        model: texts1.length / 2
        Row {
            PairedToolTipTexts {
                text1: texts1[index * 2 + 0]
                text2: texts1[index * 2 + 1]
                width1: 50
                width2: 300
            }
        }
    }
    Repeater {
        model: texts2.length / 2
        Row {
            PairedToolTipTexts {
                text1: texts2[index * 2 + 0]
                text2: texts2[index * 2 + 1]
                width1: 50
                width2: 300
            }
            visible: root.full
        }
    }
}
