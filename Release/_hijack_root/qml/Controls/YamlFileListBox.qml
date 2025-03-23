import QtQuick 2.3
import QtQuick.Controls 1.2
import Qt.labs.folderlistmodel 2.1
import "../BasicControls"
import "../Controls"
import "../_OneMakerMV"

ListBox {
    id: root

    headerVisible: false
    model: sortedListModel

    property var prefixRegexp: /^[\!\$]+/
    property var allowedSuffixes: null

    property var messageData: {}

    readonly property var currentItem: model.get(currentIndex)
    readonly property string currentBaseName: getCurrentMember("fileBaseName", "")
    readonly property string currentName: getCurrentMember("fileName", "")

    property var allIssues: ([])

    contextMenu: StandardPopupMenu {
        owner: root
        findManager: findMgr
    }

    FindManager {
        id: findMgr
        scopeTitle: qsTr("File List")
        searchableFields: ([
                               { name: "fileBaseName", title: qsTr("Filename"), hint: qsTr("The name of the file.") }
                           ])

        function getItemCount() {
            return root.rowCount;
        }

        function getItem(index) {
            return root.model.get(index);
        }

        function getCurrentIndex() {
            return root.currentIndex;
        }

        function setCurrentIndex(index) {
            root.currentIndex = index;
            root.positionViewAtIndex(root.currentIndex, ListView.Contain);
        }
    }

    function getCurrentMember(name, defaultValue) {
        return (currentItem && currentItem[name]) ? currentItem[name] : defaultValue;
    }

    signal updated()

    Palette { id: pal }

    ListBoxColumn {
        role: "text"
        elideMode: Text.ElideMiddle
    }

    ListModel {
        id: sortedListModel
    }

    style: CustomScrollViewStyle {
        property color textColor: control.enabled ? pal.normalText : pal.disabledText
        property color highlightedTextColor: control.enabled ? pal.selectedText : pal.disabledText

        property Component headerDelegate: ListBoxHeader {
        }

        property Component rowDelegate: ListBoxRow {
        }

        property Component itemDelegate: Item {
            property int implicitWidth: sizehint.paintedWidth + 20
            property bool shouldShowWarning: {
                if (root.model && root.model.get) {
                    var obj = root.model.get(styleData.row);
                    if (obj && obj.hasIssues) {
                        return true;
                    }
                }
                return false;
            }

            Text {
                id: label
                objectName: "label"
                width: parent.width
                anchors.leftMargin: 12
                anchors.left: parent.left
                anchors.right: shouldShowWarning ? warningIcon.left : parent.right
                anchors.rightMargin: 2
                horizontalAlignment: styleData.textAlignment
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1
                elide: styleData.elideMode
                text: styleData.value || ""
                color: styleData.selected ? styleData.textColor :
                                            (shouldShowWarning ? pal.disabledText : styleData.textColor)
                opacity: control.enabled ? 1 : 0.5
                font.family: pal.fixedFont
                font.pixelSize: pal.fontSize
                renderType: pal.renderType
                textFormat: Text.PlainText
            }

            Image {
                id: warningIcon
                width: 16
                height: 16
                visible: shouldShowWarning
                anchors.right: parent ? parent.right : undefined
                anchors.rightMargin: 2
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                source: ImagePack.selectedImagePack + "warning.png"
            }

            MouseArea {
                id: warningMouseArea
                anchors.fill: warningIcon
                visible: warningIcon.visible
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    var obj = root.model.get(styleData.row);
                    root.forceActiveFocus();
                    root.selectOne(styleData.row);
                    issuesDialog.issues = root.allIssues[obj.issuesIndex];
                    issuesDialog.subject = obj.fileName;
                    issuesDialog.open();
                }
            }

            Text {
                id: sizehint
                font: label.font
                text: label.text
                visible: false
                renderType: pal.renderType
                textFormat: Text.PlainText
            }
        }
    }

    FolderListModel {
        id: folderListModel
        showDirs: false
        onCountChanged: refresh()
    }

    onAllowedSuffixesChanged: {
        if (sortedListModel.count > 0) {
            refresh();
        }
    }

    onMessageDataChanged: {
        refresh()
    }

    Component.onCompleted: {
        refresh();
    }

    function makeFileExtensionIssue(fileObj) {
        var issue = {
            title: qsTr("File Extension Name"),
            description: qsTr("File names should end with “.%1” instead of “.%2”. Otherwise your game may not run correctly in case-sensitive environments, such as popular Linux web hosting services.").arg(fileObj.targetSuffix).arg(fileObj.suffix),
        };
        return issue;
    }

    function refresh() {
        var baseNames = [];
        var list = [];
        var allIssues = [];
        var atlasKeys = typeof messageData === "object" ? Object.keys(messageData) : "";

        for (var i = 0; i < atlasKeys.length; i++) {
            var baseName = atlasKeys[i];
            var noPrefixName = baseName;
            var obj = {};

            obj.fileName = baseName;
            obj.fileBaseName = baseName;

            obj.filePath = "";
            obj.prefix = baseName;
            obj.nodeName = baseName;
            obj.number = Number(obj.nodeName);
            obj.suffix = "";
            obj.targetSuffix = ""; 

            var issues = [];

            obj.hasIssues = false;
            obj.issuesIndex = -1;
            if (issues.length > 0) {
                allIssues.push(issues);
                obj.issuesIndex = allIssues.length - 1;
                obj.hasIssues = true;
            }
            obj.text = obj.fileBaseName;

            if (baseNames.indexOf(obj.fileBaseName) < 0) {
                baseNames.push(obj.fileBaseName);
                list.push(obj);
            }
        }

        root.allIssues = allIssues;
        sortedListModel.clear();
        sortedListModel.append(createEmptyItem());
        for (i = 0; i < list.length; i++) {
            sortedListModel.append(list[i]);
        }
        updated();
    }

    function createEmptyItem() {
        var obj = {}
        obj.fileBaseName = "";
        obj.text = qsTr("(None)");
        return obj;
    }

    function selectName(name) {
        for (var i = 0; i < sortedListModel.count; i++) {
            if (sortedListModel.get(i).fileBaseName === name || (Qt.platform.os === "windows" && sortedListModel.get(i).fileBaseName.toLowerCase() === name.toLowerCase())) {
                currentIndex = i;
                positionViewAtIndex(currentIndex, ListView.Center);
                break;
            }
        }
        if (currentIndex < 0) {
            currentIndex = 0;
        }
    }

    function selectInitial(initial) {
        for (var i = 0; i < sortedListModel.count; i++) {
            var index = (currentIndex + i + 1) % sortedListModel.count;
            var name = sortedListModel.get(index).text;
            if (name.toLowerCase().indexOf(initial) === 0) {
                currentIndex = index;
                positionViewAtIndex(currentIndex, ListView.Contain);
                break;
            }
        }
    }

    Keys.onPressed: {
        var initial = event.text.toLowerCase();
        if (initial.length) {
            selectInitial(initial);
        }
    }

    IssuesDialogBox {
        id: issuesDialog
    }
}
