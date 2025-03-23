import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Yaml Message Selector
EventCommandBase {
    id: root
    
    property string savedFileName1: ""
    property string savedMessageName1: ""
    property bool add1: false
    property string savedFileName2: ""
    property string savedMessageName2: ""
    property bool add2: false
    property string savedFileName3: ""
    property string savedMessageName3: ""
    property bool add3: false
    property string savedFileName4: ""
    property string savedMessageName4: ""
    property bool add4: false
    property string savedFileName5: ""
    property string savedMessageName5: ""
    property bool add5: false

    ControlsRow {
        ObjCheckBox {
            id: checkBox1
            text: qsTr("AddChoice?")
            hint: qsTr("");
            width: 110
            height: 28
            y: 18
        }
        ObjYamlEllipsisBox {
            id: yamlSelectionBox1
            title: qsTr("Yaml Message Selector")
            hint: qsTr("")
            subFolder: "languages/en"
            itemWidth: 440
            fileName: root.savedFileName1
            messageName: root.savedMessageName1

            onModified: {
                root.savedFileName2 = fileName;
                root.savedMessageName2 = messageName;
                root.add1 = true
            }
        }
        LabeledTextField {
            id: textField1
            title: qsTr("AddChoice Label")
            hint: qsTr("")
            width: 200
            y: 1
            enabled: checkBox1.checked
        }
    }
    
    ControlsRow {
        ObjCheckBox {
            id: checkBox2
            text: qsTr("AddChoice?")
            hint: qsTr("");
            width: checkBox1.width
            height: checkBox1.height
            y: 18
        }
        ObjYamlEllipsisBox {
            id: yamlSelectionBox2
            title: qsTr("Yaml Message Selector")
            hint: qsTr("")
            subFolder: "languages/en"
            itemWidth: yamlSelectionBox1.itemWidth
            fileName: root.savedFileName2
            messageName: root.savedMessageName2

            onModified: {
                root.savedFileName3 = fileName;
                root.savedMessageName3 = messageName;
                root.add2 = true
            }
        }
        LabeledTextField {
            id: textField2
            title: qsTr("AddChoice Label")
            hint: qsTr("")
            width: textField1.width
            y: 1
            enabled: checkBox2.checked
        }
    }

    ControlsRow {
        ObjCheckBox {
            id: checkBox3
            text: qsTr("AddChoice?")
            hint: qsTr("");
            width: checkBox1.width
            height: checkBox1.height
            y: 18
        }
        ObjYamlEllipsisBox {
            id: yamlSelectionBox3
            title: qsTr("Yaml Message Selector")
            hint: qsTr("")
            subFolder: "languages/en"
            itemWidth: yamlSelectionBox1.itemWidth
            fileName: root.savedFileName3
            messageName: root.savedMessageName3

            onModified: {
                root.savedFileName4 = fileName;
                root.savedMessageName4 = messageName;
                root.add3 = true
            }
        }
        LabeledTextField {
            id: textField3
            title: qsTr("AddChoice Label")
            hint: qsTr("")
            width: textField1.width
            y: 1
            enabled: checkBox3.checked
        }
    }

    ControlsRow {
        ObjCheckBox {
            id: checkBox4
            text: qsTr("AddChoice?")
            hint: qsTr("");
            width: checkBox1.width
            height: checkBox1.height
            y: 18
        }
        ObjYamlEllipsisBox {
            id: yamlSelectionBox4
            title: qsTr("Yaml Message Selector")
            hint: qsTr("")
            subFolder: "languages/en"
            itemWidth: yamlSelectionBox1.itemWidth
            fileName: root.savedFileName4
            messageName: root.savedMessageName4

            onModified: {
                root.savedFileName5 = fileName;
                root.savedMessageName5 = messageName;
                root.add4 = true
            }
        }
        LabeledTextField {
            id: textField4
            title: qsTr("AddChoice Label")
            hint: qsTr("")
            width: textField1.width
            y: 1
            enabled: checkBox4.checked
        }
    }

    ControlsRow {
        ObjCheckBox {
            id: checkBox5
            text: qsTr("AddChoice?")
            hint: qsTr("");
            width: checkBox1.width
            height: checkBox1.height
            y: 18
        }
        ObjYamlEllipsisBox {
            id: yamlSelectionBox5
            title: qsTr("Yaml Message Selector")
            hint: qsTr("")
            subFolder: "languages/en"
            itemWidth: yamlSelectionBox1.itemWidth
            fileName: root.savedFileName5
            messageName: root.savedMessageName5

            onModified: {
                root.add5 = true
            }
        }
        LabeledTextField {
            id: textField5
            title: qsTr("AddChoice Label")
            hint: qsTr("")
            width: textField1.width
            y: 1
            enabled: checkBox5.checked
        }
    }
    
    ControlsRow {
        ObjCheckBox {
            id: checkBox10
            text: qsTr("ShowChoices")
            hint: qsTr("")
            width: checkBox1.width
            height: checkBox1.height
            y: 18
        }
        ObjComboBox {
            id: comboBox
            title: qsTr("Cancel Choice")
            hint: qsTr("")
            itemWidth: 75
            model: [ -1, 0, 1, 2, 3, 4 ]
            enabled: checkBox10.checked
        }
    }

    onSave: {
        var params
        var pluginCommandText
        var dataLength
        eventData = []

        if (add1) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            if (!checkBox1.checked) {
                pluginCommandText = "ShowMessage " + yamlSelectionBox1.fileName + "." + yamlSelectionBox1.messageName;
            }
            else {
                pluginCommandText = "AddChoice " + yamlSelectionBox1.fileName + "." + yamlSelectionBox1.messageName + " " + textField1.text;
            }
            params[0] = pluginCommandText;
        }
        if (add2) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            if (!checkBox2.checked) {
                pluginCommandText = "ShowMessage " + yamlSelectionBox2.fileName + "." + yamlSelectionBox2.messageName;
            }
            else {
                pluginCommandText = "AddChoice " + yamlSelectionBox2.fileName + "." + yamlSelectionBox2.messageName + " " + textField2.text;
            }
            params[0] = pluginCommandText;
        }
        if (add3) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            if (!checkBox3.checked) {
                pluginCommandText = "ShowMessage " + yamlSelectionBox3.fileName + "." + yamlSelectionBox3.messageName;
            }
            else {
                pluginCommandText = "AddChoice " + yamlSelectionBox3.fileName + "." + yamlSelectionBox3.messageName + " " + textField3.text;
            }
            params[0] = pluginCommandText;
        }
        if (add4) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            if (!checkBox4.checked) {
                pluginCommandText = "ShowMessage " + yamlSelectionBox4.fileName + "." + yamlSelectionBox4.messageName;
            }
            else {
                pluginCommandText = "AddChoice " + yamlSelectionBox4.fileName + "." + yamlSelectionBox4.messageName + " " + textField4.text;
            }
            params[0] = pluginCommandText;
        }
        if (add5) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            if (!checkBox5.checked) {
                pluginCommandText = "ShowMessage " + yamlSelectionBox5.fileName + "." + yamlSelectionBox5.messageName;
            }
            else {
                pluginCommandText = "AddChoice " + yamlSelectionBox5.fileName + "." + yamlSelectionBox5.messageName + " " + textField5.text;
            }
            params[0] = pluginCommandText;
        }
        if (checkBox10.checked) {
            eventData.push( makeCommand(356, 0, []) );
            dataLength = eventData.length - 1;
            params = eventData[dataLength].parameters;
            pluginCommandText = "ShowChoices " + comboBox.currentText;
            params[0] = pluginCommandText;
        }
    }
}