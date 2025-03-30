import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../ObjControls"
import "../Dialogs"
import "../Singletons"

ObjEllipsisBox {
    id: root

    property int switchId: 1
    property alias includeZero: dialog.includeZero
    property alias zeroText: dialog.zeroText
    property alias selectLast: dialog.selectLast

    DialogBoxHelper { id: helper }

    Dialog_VariableSelector {
        id: dialog
        isSwitch: true

        onInit: {
            dataSet = DataManager.system.switches.slice(0);
            dataId = root.switchId;
        }

        onOk: {
            if (!DataManager.databaseModified) {
                var oldSet = JSON.stringify(DataManager.system.switches);
                var newSet = JSON.stringify(dataSet);
                if (oldSet !== newSet) {
                    DataManager.databaseModified = true;
                }
            }

            DataManager.system.switches = dataSet;
            root.switchId = dataId;
            if (member.length) {
                DataManager.setObjectValue(object, member, dataId);
            }
            updateText();
            helper.setModified();
        }

        onApply: {
            DataManager.system.switches = dataSet;
            updateText();
            helper.setModified();
        }
    }

    onWheelUp: {
        trySetCurrentId(root.switchId - 1);
    }

    onWheelDown: {
        trySetCurrentId(root.switchId + 1);
    }

    function trySetCurrentId(id) {
        if (!root.includeZero && id === 0) {
            return
        }
        else if (id >= DataManager.system.switches.length) {
            return
        }

        root.switchId = id;
        updateText();
        helper.setModified();
    }

    onObjectChanged: {
        if (member.length) {
            switchId = DataManager.getObjectValue(object, member, 1);
            updateText();
        }
    }

    onSwitchIdChanged: {
        updateText();
    }

    onClicked: {
        dialog.open();
    }

    Component.onCompleted: {
        updateText();
    }

    function updateText() {
        if (root.includeZero && switchId == 0) {
            text = root.zeroText; return;
        }

        text = DataManager.makeIdText(switchId, 4) + " ";
        text += DataManager.switchName(switchId);
    }
}
