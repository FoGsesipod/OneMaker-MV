import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Singletons"

Loader {
    id: root
    asynchronous: false
    sourceComponent: _sourceComponent

    property var _sourceComponent: {
        return updateSourceComponent();
    }

    property var    object: dataObject
    property string member: ""

    property string title: ""
    property string hint: ""
    property var    hintComponent: null

    property string dataSetName: ""
    property string systemDataName: ""
    property int    minimumLabelWidth: 0
    property bool   horizontal: false
    property bool   labelOnTop: false
    property bool   labelVisible: true
    property bool   includeZero: false
    property bool   excludeOne: false
    property string zeroText: qsTr("None")
    property string minusOneText: ""

    property int    itemWidth: 190

    signal modified()

    Component {
        id: componentSelectBox
        GameObjectBox_SelectBox {
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent

            dataSetName: root.dataSetName
            minimumLabelWidth: root.minimumLabelWidth
            horizontal: root.horizontal
            labelOnTop: root.labelOnTop
            labelVisible: root.labelVisible
            includeZero: root.includeZero
            excludeOne: root.excludeOne
            zeroText: root.zeroText
            minusOneText: root.minusOneText

            itemWidth: root.itemWidth

            member: root.member
            object: root.object

            onModified: {
                root.modified();
            }
        }
    }

    Component {
        id: componentEllipsisBox
        GameObjectBox_EllipsisBox {
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent

            dataSetName: root.dataSetName
            minimumLabelWidth: root.minimumLabelWidth
            horizontal: root.horizontal
            labelOnTop: root.labelOnTop
            labelVisible: root.labelVisible
            includeZero: root.includeZero
            excludeOne: root.excludeOne
            zeroText: root.zeroText
            minusOneText: root.minusOneText

            itemWidth: root.itemWidth

            member: root.member
            object: root.object

            onModified: {
                root.modified();
            }
        }
    }

    Component {
        id: componentSystemSelectBox
        ObjSelectBox {
            title: root.title
            hint: root.hint
            hintComponent: root.hintComponent

            dataSetName: root.dataSetName
            systemDataName: root.systemDataName
            minimumLabelWidth: root.minimumLabelWidth
            horizontal: root.horizontal
            labelOnTop: root.labelOnTop
            labelVisible: root.labelVisible
            includeZero: root.includeZero
            excludeOne: root.excludeOne
            zeroText: root.zeroText
            minusOneText: root.minusOneText

            itemWidth: root.itemWidth

            member: root.member
            object: root.object

            onModified: {
                root.modified();
            }
        }
    }

    readonly property int currentId: root.item ? root.item.currentId : 0

    function setCurrentId(id) {
        root.item.setCurrentId(id);
    }

    onDataSetNameChanged: {
        updateSourceComponent();
    }

    function updateSourceComponent() {
        if (dataSetName === "system") {
            return (_sourceComponent = componentSystemSelectBox);
        }

        // [OneMaker MV] - Force use "extended" to fix bugs.
        return (_sourceComponent = componentEllipsisBox);

        switch (SettingsManager.storage.objectSelector) {
        case "extended":
            return (_sourceComponent = componentEllipsisBox);
        case "smart":
            try {
                if ((DataManager.getDataSet(dataSetName).length - 1) >= 100) {
                    return (_sourceComponent = componentEllipsisBox);
                } else {
                    return (_sourceComponent = componentSelectBox);
                }
            } catch (e) {
                return (_sourceComponent = componentEllipsisBox);
            }
        default:
            return (_sourceComponent = componentSelectBox);
        }
    }
}
