import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"

ControlsRow {
    id: root

    property string member: ""
    property string seName: ""
    property var pluginNames: []
    property var arrayNames: []
    property var dataObject: null

    property alias value1: sliderSpin1.value
    property alias value2: sliderSpin2.value
    property alias value3: sliderSpin3.value

    ControlsColumn {
        id: sliderColumn
        ObjSliderSpinBox {
            id: sliderSpin1
            member: root.member.length ? root.member + ".0" : ""
            title: qsTr("No Value")
            hint: qsTr("")
            minimumValue: 0
            maximumValue: 255
            value: 255
            stepSize: 17
            minimumLabelWidth: 70
        }
        ObjSliderSpinBox {
            id: sliderSpin2
            member: root.member.length ? root.member + ".1" : ""
            title: qsTr("No Value")
            hint: qsTr("")
            minimumValue: 0
            maximumValue: 255
            value: 255
            stepSize: 17
            minimumLabelWidth: 70
        }
        ObjSliderSpinBox {
            id: sliderSpin3
            member: root.member.length ? root.member + ".2" : ""
            title: qsTr("No Value")
            hint: qsTr("")
            minimumValue: 0
            maximumValue: 255
            value: 255
            stepSize: 17
            minimumLabelWidth: 70
        }
    }

    onSeNameChanged: {
        pluginParameters();
        arrayChange();
    }

    Component.onCompleted: {
        pluginParameters();
        arrayChange();
    }

    function arrayChange() {
        var arrayIndex = pluginNames.indexOf(seName);
        var array = [];

        switch (arrayIndex) {
            case 0: // Shake SE
                array = ["Power", "Speed", null];
                break;
            case 1: // Blur SE
                array = ["Intensity", null, null];
                break;
            case 2: // Zoom Blur SE
                array = ["Intensity", "Radius", null];
                break;
            case 3: // Glow SE
                array = ["Intensity", "Size", "Threshold"];
                break;
            case 4: // Wave SE
                array = ["Intensity", "Width", null];
                break;
            case 5:
                array = ["Intensity", "Density", "Seperation"]
                break;
        }

        arrayNames = array;
        labelNames();
        controlEnabler();
    }

    function controlEnabler() {
        sliderSpin1.enabled = arrayNames[0] ? true : false;
        sliderSpin2.enabled = arrayNames[1] ? true : false;
        sliderSpin3.enabled = arrayNames[2] ? true : false;
    }

    function labelNames() {
        sliderSpin1.title = arrayNames[0] ? arrayNames[0] : "No Value";
        sliderSpin2.title = arrayNames[1] ? arrayNames[1] : "No Value";
        sliderSpin3.title = arrayNames[2] ? arrayNames[2] : "No Value";
    }

    function pluginParameters() {
        var dataArray = DataManager.plugins;

        for (var i = 0; i < dataArray.length; i++) {
            if (dataArray[i].name === "Aries001_AnimationScreenEffects") {
                var parameters = dataArray[i].parameters;
                var model = [parameters["Shake SE"], parameters["Blur SE"], parameters["ZoomBlur SE"], parameters["Glow SE"], parameters["Wave SE"], parameters["Distort SE"]];

                pluginNames = model;
                break;
            }
        }
    }

    function setup(param) {
        value1 = param[0];
        value2 = param[1];
        value3 = param[2];
        value4 = param[3];
    }
}
