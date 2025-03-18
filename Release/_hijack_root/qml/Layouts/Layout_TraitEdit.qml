import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Dialogs"

Row {
    id: root

    property int code
    property bool percentValue: true
    property int defaultValue: 1

    property alias title: radioButton.text
    property alias hint: radioButton.hint
    property alias exclusiveGroup: radioButton.exclusiveGroup
    property alias selected: radioButton.checked

    property alias model: comboBox.model
    property alias dataSetName: selectBox.dataSetName
    property alias systemDataName: selectBox.systemDataName
    property alias includeZero: selectBox.includeZero
    property alias zeroText: selectBox.zeroText
    property alias valueVisible: spinBox.visible
    property alias minimumValue: spinBox.minimumValue
    property alias maximumValue: spinBox.maximumValue
    property alias operatorText: operator.text

    readonly property int dataId: {
        if (model.length > 0) {
            return comboBox.currentIndex;
        } else if (dataSetName.length > 0) {
            return selectBox.currentId;
        } else {
            return 0;
        }
    }

    readonly property real value: {
        return spinBox.value / (percentValue ? 100 : 1);
    }

    readonly property Item firstFocusItem: {
        if (spinBox.visible) {
            return spinBox;
        } else if (comboBox.visible) {
            return comboBox;
        } else if (selectBox.visible) {
            return selectBox;
        } else {
            return radioButton;
        }
    }

    readonly property Item radioButton: radioButton

    RadioButton {
        id: radioButton
        width: 120
        height: 28
    }

    ControlsColumn {
        Item {
            width: 20
            height: 4
        }
        Item {
            width: 20
            height: 20
            visible: comboBox.visible || selectBox.visible
        }
        Label {
            id: operator
            width: 20
            text: "*"
            horizontalAlignment: Text.AlignHCenter
            visible: valueVisible
        }
        enabled: radioButton.checked
    }

    ControlsColumn {
        ComboBox {
            id: comboBox
            title: root.title
            hint: root.hint
            width: 170
            visible: model.length > 0
        }
        GameObjectBox {
            id: selectBox
            title: root.title
            hint: root.hint
            labelVisible: false
            horizontal: true
            itemWidth: 170
            visible: dataSetName.length > 0
        }
        SpinBox {
            id: spinBox
            title: root.title
            hint: root.hint
            visible: false
            suffix: percentValue ? " %" : ""
            value: defaultValue * (percentValue ? 100 : 1)
            decimals: 1
            minimumValue: 0
            maximumValue: 10000 // [OneMaker MV] - Increased Maximum
            width: 90
        }
        enabled: radioButton.checked
    }

    function select(dataId, value) {
        root.selected = true;
        if (comboBox.visible) {
            comboBox.currentIndex = dataId;
        } else if (selectBox.visible) {
            selectBox.setCurrentId(dataId);
        }
        spinBox.value = value * (percentValue ? 100 : 1);
    }
}
