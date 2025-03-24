import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

ModalWindow {
    id: root

    title: qsTr("Parameter Curves")

    property var paramArray: null
    property int paramId: 0
    property bool pageChanging: false

    Palette { id: pal }

    DialogBox {
        applyVisible: false

        TabView {
            id: base
            width: 600
            height: 400

            property int clientHeight

            Component.onCompleted: {
                for (var i = 0; i < Constants.patamMax; i++) {
                    base.addTab(Constants.paramNameArray[i]);
                }
                base.currentIndex = paramId;
                clientHeight = base.getTab(0).height;
            }

            Dialog_GenerateCurve {
                id: dialog
                onOk: {
                    //valueBox.value = value1;
                    base.generateParameters(value1, value2, growth);
                    base.updateValueBox();
                }
            }

            Item {
                width: base.width
                height: base.clientHeight

                TabColumn {
                    ControlsRow {
                        id: controlArea
                        GroupBox {
                            id: quick
                            title: qsTr("Quick Setting")
                            hint: qsTr("Press buttons to set parameter values randomly within a predefined range.")

                            property int buttonWidth: 30
                            property var buttonNames: ["A","B","C","D","E"]

                            Row {
                                Repeater {
                                    model: 5
                                    Button {
                                        text: quick.buttonNames[index]
                                        width: quick.buttonWidth
                                        title: quick.title
                                        hint: quick.hint
                                        onClicked: base.quickSetParameters(4 - index)
                                    }
                                }
                            }
                        }
                        ControlsRow {
                            anchors.margins: 8
                            anchors.bottom: parent.bottom
                            Item {
                                width: 2
                                height: 1
                            }
                            LabeledSpinBox {
                                id: levelBox
                                title: qsTr("Level")
                                hint: qsTr("Specifies a level for manual parameter changing.")
                                itemWidth: 80
                                anchors.bottom: parent.bottom
                                minimumValue: 1
                                maximumValue: OneMakerMVSettings.getSetting("maxLevel", "maximun") // [OneMaker MV] - Change to use MaxLevel's value
                                onValueChanged: {
                                    base.updateValueBox();
                                }
                            }
                            Label {
                                text: ">"
                                height: 26
                                anchors.bottom: parent.bottom
                            }
                            LabeledSpinBox {
                                id: valueBox
                                title: qsTr("Value")
                                hint: qsTr("Changes the parameter value for the specified level.")
                                itemWidth: 80
                                anchors.bottom: parent.bottom
                                minimumValue: Constants.paramMinArray[paramId]
                                maximumValue: Constants.paramMaxArray[paramId]
                                onValueChanged: {
                                    if (!pageChanging) {
                                        base.setParameterValue(levelBox.value, value);
                                    }
                                }
                            }
                            Item {
                                width: 2
                                height: 1
                            }
                            Button {
                                text: qsTr("Generate Curve") + "..."
                                hint: qsTr("Specifies values for level 1 and 99 and the remaining values will be filled in automatically.")
                                width: 160
                                anchors.bottom: parent.bottom
                                onClicked: {
                                    dialog.minimumValue = valueBox.minimumValue;
                                    dialog.maximumValue = valueBox.maximumValue;
                                    dialog.value1 = base.getParameterValue(1);
                                    dialog.value2 = base.getParameterValue(OneMakerMVSettings.getSetting("maxLevel", "maximun")); // [OneMaker MV] - Get Maximun Level
                                    dialog.growth = 10;
                                    dialog.open();
                                }
                            }
                        }
                    }

                    CanvasBox {
                        id: graphArea
                        title: qsTr("Parameter graph")
                        hint: qsTr("The X axis is the level number, and the Y axis shows the parameter value at each level. Click to get the parameter value.")
                        width: parent.width
                        height: parent.height - controlArea.height - parent.spacing
                        showActiveFocus: false
                        Component.onCompleted: {
                            root.firstFocusItem = graphArea;
                        }
                        onPaint: base.paintGraph()

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: parent.canvasMargin

                            onPressed: {
                                parent.forceActiveFocus();
                                changeLevel();
                            }
                            onPositionChanged: {
                                if (pressed) {
                                    changeLevel();
                                }
                            }
                            function changeLevel() {
                                var barWidth = graphArea.canvasWidth / OneMakerMVSettings.getSetting("maxLevel", "maximun"); // [OneMaker MV] - Change to use MaxLevel's value
                                levelBox.value = Math.floor(mouseX / barWidth) + 1;
                            }
                        }
                    }
                }
            }

            onCurrentIndexChanged: {
                pageChanging = true;
                paramId = currentIndex;
                updateValueBox();
                pageChanging = false;
                graphArea.requestPaint();
            }

            function updateValueBox() {
                valueBox.value = base.getParameterValue(levelBox.value);
            }

            function getParameterValue(level) {
                return paramArray[paramId][level];
            }

            function setParameterValue(level, value) {
                paramArray[paramId][level] = value;
                graphArea.requestPaint();
            }

            function paintGraph() {
                var context = graphArea.context;
                if (context) {
                    context.fillStyle = pal.normalBack1;
                    context.fillRect(0, 0, graphArea.canvasWidth, graphArea.canvasHeight);
                    var barWidth = graphArea.canvasWidth / OneMakerMVSettings.getSetting("maxLevel", "maximun"); // [OneMaker MV] - Change to use MaxLevel's value
                    var maxValue = Constants.paramGraphMaxArray[paramId];
                    context.fillStyle = Constants.paramColorArray[paramId];
                    for (var i = 0; i < OneMakerMVSettings.getSetting("maxLevel", "maximun"); i++) { // [OneMaker MV] - Change to use MaxLevel's value
                        var n = getParameterValue(i + 1) * graphArea.canvasHeight / maxValue;
                        context.fillRect(i * barWidth, graphArea.canvasHeight - n, barWidth + 1, n);
                    }
                }
            }

            function generateParameters(value1, value2, growth) {
                var a = value1;
                var b = value2;
                var c = growth - 10;
                for (var i = 1; i <= OneMakerMVSettings.getSetting("maxLevel", "maximun"); i++) { // [OneMaker MV] - Change to use MaxLevel's value
                    var n1 = a + ((b - a) * (i - 1) / (OneMakerMVSettings.getSetting("maxLevel", "maximun") - 1)); // [OneMaker MV] - Change to use MaxLevel's value
                    var n2 = a + ((b - a) * (i - 1) * (i - 1) / (OneMakerMVSettings.getSetting("maxLevel", "maximun") - 1) / (OneMakerMVSettings.getSetting("maxLevel", "maximun") - 1)); // [OneMaker MV] - Change to use MaxLevel's value
                    var x = Math.ceil((n2 * c + n1 * (10 - c)) / 10);
                    setParameterValue(i, x);
                }
            }

            function quickSetParameters(rank) {
                var maxValue = Constants.paramGraphMaxArray[paramId];
                var value1 = 200 + rank * 100 + Math.random() * 100;
                var value2 = 4000 + rank * 1000 + Math.random() * 1000;
                value1 *= maxValue / 10000;
                value2 *= maxValue / 10000;
                if (paramId >= 2) {
                    value1 += 5;
                }
                value1 = Math.round(value1);
                value2 = Math.round(value2);
                generateParameters(value1, value2, 10);
                updateValueBox();
            }
        }
    }
}
