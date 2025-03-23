import QtQuick 2.3
import QtQuick.Controls 1.2
import Tkool.rpg 1.0
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../Singletons"
import "../Scripts/JsonTemplates.js" as JsonTemplates
import "../_OneMakerMV"

TreeBox {
    id: root

    implicitWidth: 256 + 16 + 2
    implicitHeight: 20 * 20 + 2

    dragDrop: false
    cacheBuffer: 1000

    property string rootIcon: ImagePack.selectedImagePack + "tree-root.png" // [OneMaker MV] - Obtain Image Pack
    property string mapIcon: ImagePack.selectedImagePack + "tree-map.png" // [OneMaker MV] - Obtain Image Pack
    property alias findModality: findMgr.modality

    readonly property bool projectOpened: DataManager.projectOpened
    readonly property string gameTitle: DataManager.gameTitle
    readonly property FindManager findManager: findMgr

    signal refresh()
    signal mapLoad()

    children: Item {
        FindManager {
            id: findMgr
            scopeTitle: qsTr("Map List")
            searchableFields: ([
                { name: "name", title: qsTr("Name"), hint: qsTr("Name of the map.") },
                { name: "displayName", title: qsTr("Display Name"), hint: qsTr("Name displayed on the upper left part of the screen when moving to the map."), initial: false },
                { name: "note", title: Constants.noteTitle, hint: Constants.noteDesc , initial: false },
            ])

            function getItemCount() {
                return root.count;
            }

            function getItem(index) {
                var id = root.getId(index);
                var item = {};

                if (DataManager.mapInfos[id]) {
                    item.name = DataManager.mapInfos[id].name;
                }

                if (findConfig.fields.indexOf("displayName") >= 0 || findConfig.fields.indexOf("note") >= 0) {
                    if (!DataManager.maps[id]) {
                        DataManager.loadMap(id);
                    }
                    if (DataManager.maps[id]) {
                        item.displayName = DataManager.maps[id].displayName;
                        item.note = DataManager.maps[id].note;
                    }
                }

                return item;
            }

            function getCurrentIndex() {
                return root.currentIndex;
            }

            function setCurrentIndex(index) {
                root.expandAncestors(index);
                root.ensureVisible(index, index);
                root.currentIndex = index;
            }
        }
    }

    Component.onCompleted: {
        refresh();
    }

    onProjectOpenedChanged: {
        refresh();
    }

    onGameTitleChanged: {
        changeText(0, gameTitle)
    }

    onRefresh: {
        clear();
        if (DataManager.projectOpened) {
            append(-1, 0, gameTitle, rootIcon, true);
            var mapIdArray = [];
            var mapInfos = DataManager.mapInfos;
            for (var i = 0; i < mapInfos.length; i++) {
                if (mapInfos[i]) {
                    mapIdArray.push(i);
                }
            }
            mapIdArray.sort(function(a, b) {
                return mapInfos[a].order - mapInfos[b].order;
            });
            for (var j = 0; j < mapIdArray.length; j++) {
                appendMap(mapIdArray[j]);
            }
            update();
        }
    }

    onCurrentIdChanged: {
        if (!branchMoving) {
            if (DataManager.projectOpened) {
                if (currentId > 0 && !DataManager.maps[currentId]) {
                    if (!DataManager.loadMap(currentId)) {
                        DataManager.maps[currentId] = JSON.parse(JsonTemplates.Map);
                        DataManager.maps[currentId].mapId = currentId;
                    }
                }
                mapLoad();
            } else {
                mapLoad();
            }
        }
    }

    function appendMap(mapId) {
        var info = DataManager.mapInfos[mapId];
        if (info && find(mapId) < 0) {
            if (find(info.parentId) < 0 && info.parentId !== mapId) {
                appendMap(info.parentId);
            }
            append(info.parentId, mapId, info.name, mapIcon, info.expanded);
        }
    }
}
