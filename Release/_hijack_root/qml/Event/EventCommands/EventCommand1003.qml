import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Map"
import "../../Singletons"

EventCommandBase {
    id: root

    readonly property int mapIdValue: locationBox.mapId
    readonly property int mapXValue: locationBox.mapX
    readonly property int mapYValue: locationBox.mapY
    property int directionValue: Constants.directionValue(directionSelectBox.currentText)

    GroupBox {
        height: 60
        LocationBox {
            id: locationBox
            title: qsTr("Select A Location")
            hint: qsTr("")
            itemWidth: 203
            y: -23
            needMapSelection: true
        }
    }

    GroupBox {
        height: 60
        ControlsRow {
            LabeledComboBox {
                id: directionSelectBox
                title: qsTr("Direction")
                hint: qsTr("Direction of the character after moving.")
                model: Constants.directionNameArrayForTransfer
                itemWidth: 96
                y: -23
            }

            LabeledComboBox {
                id: fadeTypeSelectBox
                title: qsTr("Fade")
                hint: qsTr("Type of screen transition when moving.")
                model: Constants.fadeTypeArray
                itemWidth: 96
                y: -23
            }
        }
    }

    Group_Duration {
        id: fadeDuration
        title: qsTr("Fade Duration")
        hint: qsTr("")
        enabled: fadeTypeSelectBox.currentIndex != 2
    }

    GroupBox {
        height: 60
        Item {
            width: 203
            visible: false
        }
        ObjCheckBox {
            id: createTeleportingStyle
            text: qsTr("Create Teleporting Style")
            hint: qsTr("")
            y: -18
            x: 2
        }
        ObjCheckBox {
            id: createFadeInScreen
            text: qsTr("Create Fade In Screen")
            hint: qsTr("")
            y: 8
            x: 2
        }
    }

    Component.onCompleted: {
        createTeleportingStyle.checked = true
        createFadeInScreen.checked = true
    }

    onSave: {
        var scriptCommandText = "// MapID\n" +
                                "$gameVariables.setValue(9, " + mapIdValue + ");\n" +
                                "// X\n" +
                                "$gameVariables.setValue(10, " + mapXValue + ");\n" +
                                "// Y\n" +
                                "$gameVariables.setValue(11, " + mapYValue + ");\n" +
                                "// Direction\n" +
                                "$gameVariables.setValue(12, " + directionValue + ");\n" +
                                "// Fade Type (0 - Black, 1 - White, 2 - None)\n" +
                                "$gameVariables.setValue(13, " + fadeTypeSelectBox.currentIndex + ");\n" +
                                "// Fade Duration\n" +
                                "$gameVariables.setValue(14, " + fadeDuration.value + ");"
        var lines = scriptCommandText.split("\n");
        eventData = [];
        
        while (lines.length > 1 && lines[lines.length - 1].length === 0) {
            lines.pop();
        }
        for (var i = 0; i < lines.length; i++) {
            var code = (i === 0 ? 355 : 655);
            eventData.push( makeCommand(code, 0, [lines[i]]) );
        }
        if (createTeleportingStyle.checked) {
            eventData.push( makeCommand(117, 0, [31]) )
        }
        if (createFadeInScreen.checked) {
            eventData.push( makeCommand(117, 0, [32]) )
        }
    }
}