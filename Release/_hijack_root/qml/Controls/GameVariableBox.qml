import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"

ObjEllipsisBox {
    id: root

    property int variableId: 1
    property alias includeZero: dialog.includeZero
    property alias zeroText: dialog.zeroText
    property alias selectLast: dialog.selectLast

    DialogBoxHelper { id: helper }

    Dialog_VariableSelector {
        id: dialog
        isSwitch: false

        onInit: {
            dataSet = DataManager.system.variables.slice(0);
            dataId = root.variableId;
        }

        onOk: {
            if (!DataManager.databaseModified) {
                var oldSet = JSON.stringify(DataManager.system.variables);
                var newSet = JSON.stringify(dataSet);
                if (oldSet !== newSet) {
                    DataManager.databaseModified = true;
                }
            }

            DataManager.system.variables = dataSet;
            root.variableId = dataId;
            if (member.length) {
                DataManager.setObjectValue(object, member, dataId);
            }
            updateText();
            helper.setModified();
        }

        onApply: {
            DataManager.system.variables = dataSet;
            updateText();
            helper.setModified();
        }
    }

    onWheelUp: {
        trySetCurrentId(root.variableId - 1);
    }

    onWheelDown: {
        trySetCurrentId(root.variableId + 1);
    }

    function trySetCurrentId(id) {
        if (!root.includeZero && id === 0) {
            return
        }
        else if (id >= DataManager.system.variables.length) {
            return
        }

        root.variableId = id;
        updateText();
        helper.setModified();
    }

    onObjectChanged: {
        if (member.length) {
            variableId = DataManager.getObjectValue(object, member, 1);
            updateText();
        }
    }

    onVariableIdChanged: {
        updateText();
    }

    onClicked: {
        dialog.open();
    }

    Component.onCompleted: {
        updateText();
    }

    function updateText() {
        if (root.includeZero && variableId == 0) {
            text = root.zeroText; return;
        }

        text = DataManager.makeIdText(variableId, 4) + " ";
        text += DataManager.variableName(variableId);
    }
}
