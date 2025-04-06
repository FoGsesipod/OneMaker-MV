import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Layouts"
import "../ObjControls"
import "../Singletons"
import "../_OneMakerMV"

ModalWindow {
    id: root

    property var dataSet: null
    property int dataId: 0
    property int spacing: 10
    property bool isSwitch: true
    property bool selectLast: true

    property bool includeZero: false
    property string zeroText: qsTr("None")

    readonly property string dataSetName: isSwitch ? "switches" : "variables"
    readonly property string clipboardFormat: dataSetName

    readonly property int groupSize: 20

    property int groupIndexOffset: (includeZero ? 1 : 0)
    property var groupIndexSpecialId: ([])

    title: isSwitch ? qsTr("Switch Selector") : qsTr("Variable Selector")

    DialogBox {
        id: dialogBox

        onInit: {
            var dataId = root.dataId;
            if (selectLast) {
                dataId = isSwitch ? DataManager.lastSwitchId : DataManager.lastVariableId;
                root.dataId = dataId;
            }
            base.updateGroupList();
            base.setDataId(dataId);
        }

        ControlsRow {
            id: base
            spacing: root.spacing

            ListModel { id: groupListModel }
            ListModel { id: dataListModel }

            function updateGroupList() {
                var lastIndex = groupList.currentIndex;
                var dataMax = getDataMax();
                var groupMax = Math.ceil(dataMax / groupSize);
                var startId, endId, text;
                groupListModel.clear();
                groupIndexSpecialId = [];

                if (root.includeZero) {
                    groupIndexSpecialId.push(0);
                    groupListModel.append({ text: root.zeroText });
                }

                for (var i = 0; i < groupMax; i++) {
                    startId = i * groupSize + 1;
                    endId = Math.min(startId + groupSize - 1, dataMax);
                    text = "[ " + DataManager.makeIdText(startId, 4) + " - "
                            + DataManager.makeIdText(endId, 4) + " ]";
                    groupListModel.append({ text: text });
                }

                if (lastIndex >= 0) {
                    groupList.currentIndex = Math.min(lastIndex, groupListModel.count - 1);
                }
            }

            function setDataId(dataId) {
                root.dataId = dataId;
                if (dataId === 0 && root.includeZero) {
                    groupList.currentIndex = groupIndexSpecialId.indexOf(dataId);
                } else if (dataId >= 1 && dataId <= base.getDataMax()) {
                    groupList.currentIndex = groupIndexOffset + Math.floor((dataId - 1) / groupSize);
                    dataList.currentIndex = (dataId - 1) % groupSize;
                } else {
                    groupList.currentIndex = groupIndexOffset + 0;
                    dataList.currentIndex = 0;
                }

                groupList.positionViewAtIndex(groupList.currentIndex, ListView.Contain);
            }

            function updateDataList() {
                if (groupList.currentIndex < groupIndexOffset) {
                    dataListModel.clear();
                    dataList.enabled = false;
                    nameEdit.enabled = false;
                    updateDataId();
                    return;
                }

                var lastIndex = dataList.currentIndex;
                var dataMax = getDataMax();
                var startId = (groupList.currentIndex - groupIndexOffset) * groupSize + 1;
                dataListModel.clear();
                dataList.enabled = true;
                nameEdit.enabled = true;
                for (var i = 0; i < groupSize; i++) {
                    var id = startId + i;
                    if (id >= 1 && id <= dataMax) {
                        dataListModel.append({ text: makeDataText(id) });
                    }
                }
                if (lastIndex >= 0) {
                    dataList.currentIndex = Math.min(lastIndex, dataListModel.count - 1);
                    updateDataId();
                }
            }

            function getDataMax() {
                return dataSet ? dataSet.length - 1 : 0;
            }

            function makeDataText(id) {
                return DataManager.makeIdText(id, 4) + " " + dataSet[id];
            }

            function updateDataId() {
                if (groupList.currentIndex < groupIndexOffset) {
                    dataId = groupIndexSpecialId[groupList.currentIndex];
                    return;
                }

                dataId = (groupList.currentIndex - groupIndexOffset) * 20 + dataList.currentIndex + 1;
                if (dataId >= 1) {
                    nameEdit.text = dataSet[dataId];
                } else {
                    dataId = 0;
                    nameEdit.text = "";
                }
                if (isSwitch) {
                    DataManager.lastSwitchId = dataId;
                } else {
                    DataManager.lastVariableId = dataId;
                }
            }

            function updateListName(id) {
                var index = id - ((groupList.currentIndex - groupIndexOffset) * groupSize + 1);
                if (index >= 0 && index < dataList.rowCount) {
                    dataListModel.set(index, { text: makeDataText(id) })
                }
            }

            function updateCurrentName() {
                updateListName(dataId)
            }

            function changeDataName() {
                if (dataSet[dataId] !== nameEdit.text) {
                    dataSet[dataId] = nameEdit.text;
                    dialogBox.setModified();
                    updateCurrentName();
                }
            }

            function changeMaximum(n) {
                while (dataSet.length < n + 1) {
                    dataSet.push("");
                }
                dataSet.length = n + 1;
                updateGroupList();
                updateDataList();
            }

            function copy() {
                var clipData = [];
                var startId = (groupList.currentIndex - groupIndexOffset) * groupSize + 1;
                for (var i = 0; i < dataList.rowCount; i++) {
                    if (dataList.isSelected(i)) {
                        var id = startId + i;
                        clipData.push(dataSet[id]);
                    }
                }
                if (clipData.length) {
                    Clipboard.setData(clipboardFormat, JSON.stringify(clipData));
                }
            }

            function paste() {
                var clipData = JSON.parse(Clipboard.getData(clipboardFormat));
                if (clipData) {
                    var dataMax = getDataMax();
                    var startId = (groupList.currentIndex - groupIndexOffset) * groupSize + 1;
                    var pasteCount = 0;
                    for (var i = 0; i < clipData.length; i++) {
                        var id = startId + dataList.currentIndex + i;
                        if (id >= 1 && id <= dataMax) {
                            dataSet[id] = clipData[i];
                            updateListName(id);
                            pasteCount++;
                        }
                    }
                    if (pasteCount > 0) {
                        var baseIndex = dataList.currentIndex;
                        dataList.currentIndex = -1;
                        dataList.selectRange(baseIndex, baseIndex + pasteCount - 1);
                        helper.setModified();
                    }
                }
            }

            function clear() {
                var startId = (groupList.currentIndex - groupIndexOffset) * groupSize + 1;
                for (var i = 0; i < dataList.rowCount; i++) {
                    if (dataList.isSelected(i)) {
                        var id = startId + i;
                        dataSet[id] = "";
                        updateListName(id);
                    }
                }
                helper.setModified();
                dataList.reselect();
            }

            function selectNext() {
                if (groupList.currentIndex < root.groupIndexOffset) {
                    groupList.incrementCurrentIndex();
                    dataList.currentIndex = 0;
                } else if (dataList.currentIndex === dataList.rowCount - 1) {
                    if (groupList.currentIndex < groupList.rowCount - 1) {
                        groupList.incrementCurrentIndex();
                        dataList.currentIndex = 0;
                    }
                } else {
                    dataList.incrementCurrentIndex();
                }
            }

            function selectPrevious() {
                if (groupList.currentIndex > 0 && groupList.currentIndex < root.groupIndexOffset) {
                    groupList.decrementCurrentIndex();
                } if (dataList.currentIndex === 0) {
                    if (dataId > 1) {
                        groupList.decrementCurrentIndex();
                        dataList.currentIndex = groupSize - 1;
                    } else if (root.groupIndexOffset > 0) {
                        groupList.decrementCurrentIndex();
                    }
                } else {
                    dataList.decrementCurrentIndex();
                }
            }

            Action {
                shortcut: root.visible ? "F5" : ""
                onTriggered: base.selectNext()
            }

            Action {
                shortcut: root.visible ? "F4" : ""
                onTriggered: base.selectPrevious()
            }

            Column {
                id: leftBlock
                width: 160
                spacing: root.spacing

                DeluxeLabel {
                    id: label
                    width: parent.width
                    text: isSwitch ? qsTr("Switches") : qsTr("Variables")
                    hint: isSwitch ? qsTr("Data to be stored ON/OFF values throughout the game.")
                                   : qsTr("Data to be stored integer values throughout the game.")
                }

                ListBox {
                    id: groupList
                    title: qsTr("Group List")
                    hint: isSwitch ? qsTr("The switches in the selected range are displayed on the right.")
                                   : qsTr("The variables in the selected range are displayed on the right.")

                    width: parent.width
                    height: 382
                    model: groupListModel
                    headerVisible: false

                    ListBoxColumn { role: "text" }

                    onCurrentIndexChanged: base.updateDataList()

                    contextMenu: StandardPopupMenu {
                        owner: groupList
                        findManager: findMgr
                    }
                }

                Button {
                    id: button
                    width: parent.width
                    text: qsTr("Change Maximum") + "..."
                    hint: qsTr("Changes the number of data entries.")
                    onClicked: {
                        changeMaxDialog.value = base.getDataMax();
                        changeMaxDialog.open();
                    }
                    KeyNavigation.left: groupList
                    KeyNavigation.right: groupList
                    KeyNavigation.up: groupList
                    KeyNavigation.down: groupList
                }
            }

            RoundFrame {
                id: rightBlock
                width: 244 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                height: leftBlock.height

                Item {
                    anchors.fill: parent
                    anchors.margins: 12

                    Column {
                        width: 220 + OneMakerMVSettings.getWindowSetting("defaultWidthIncrease") // [OneMaker MV] - Window Increased
                        spacing: 12

                        ListBox {
                            id: dataList
                            title: qsTr("Data List")
                            hint: (isSwitch ? qsTr("List for selecting switches.")
                                            : qsTr("List for selecting variables."))
                                  + qsTr("<br>[F5] Selects the next item.<br>[F4] Selects the previous item.")
                            width: parent.width
                            height: 402
                            model: dataListModel
                            headerVisible: false
                            multiSelect: true
                            cancelMultiSelectOnLostFocus: true

                            ListBoxColumn { role: "text" }

                            onCurrentIndexChanged: base.updateDataId()
                            onDoubleClicked: dialogBox.ok()

                            contextMenu: StandardPopupMenu {
                                owner: dataList
                                clipboardFormat: root.clipboardFormat
                                validItemSelected: dataList.currentIndex >= 0
                                useCopy: true
                                usePaste: true
                                useClear: true
                                onEditCopy: base.copy()
                                onEditPaste: base.paste()
                                onEditClear: base.clear()
                                findManager: findMgr
                            }
                        }

                        LabeledTextField {
                            id: nameEdit
                            title: qsTr("Name")
                            hint: isSwitch ? qsTr("Name of the switch.") : qsTr("Name of the variable.")
                            width: parent.width
                            horizontal: true
                            minimumLabelWidth: 40
                            itemWidth: 164
                            onTextChanged: base.changeDataName()
                        }
                    }
                }
            }
        }

        Dialog_ChangeMaximum {
            id: changeMaxDialog
            locator: button
            maximumNumberOfItems: 10000 // [OneMaker MV] - Increased by 5000
            onOk: base.changeMaximum(value);
        }

        onApply: {
            applyEnabled = false;
        }

        FindManager {
            id: findMgr

            searchableFields: ([
                { name: "name", title: nameEdit.title, hint: nameEdit.hint },
            ])
            scopeTitle: label.text

            function getItemCount() {
                return base.getDataMax();
            }

            function getItem(index) {
                return { name: dataSet[index] };
            }

            function getCurrentIndex() {
                return dataId;
            }

            function setCurrentIndex(index) {
                base.setDataId(index);
            }
        }
    }
}
