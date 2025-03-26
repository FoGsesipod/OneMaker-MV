import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Singletons"

Menu {
    id: root

    property Item owner: null
    property bool findNextEnabled: false
    property bool findPreviousEnabled: false

    property FindManager findManager: null

    property alias useFind: menuFind.visible
    property alias useFindNext: menuFindNext.visible
    property alias useFindPrevious: menuFindPrevious.visible

    signal editFind()
    signal editFindNext()
    signal editFindPrevious()

    signal updateMenuItems()

    readonly property bool _shortcutEnabled: owner && owner.activeFocus && root.enabled

    MenuItem {
        id: menuFind
        text: qsTr("Find") + "..."
        enabled: visible
        visible: !!findManager || false
        onTriggered: {
            if (findManager) {
                findManager.find();
            } else {
                editFind();
            }

            updateMenuItems();
            TutorialManager.onActionTriggered("Find", this);
        }
    }

    MenuItem {
        id: menuFindNext
        text: qsTr("Find Next")
        enabled: findManager ? findManager.hasConfig : (visible && findNextEnabled)
        visible: !!findManager || false
        onTriggered: {
            if (findManager) {
                findManager.findNext();
            } else {
                editFindNext();
            }

            updateMenuItems();
            TutorialManager.onActionTriggered("FindNext", this);
        }
    }

    MenuItem {
        id: menuFindPrevious
        text: qsTr("Find Previous")
        enabled: findManager ? findManager.hasConfig : (visible && findPreviousEnabled)
        visible: !!findManager || false
        onTriggered: {
            if (findManager) {
                findManager.findPrevious();
            } else {
                editFindPrevious();
            }

            updateMenuItems();
            TutorialManager.onActionTriggered("FindNextPrevious", this);
        }
    }

    onPopupVisibleChanged: {
        updateMenuItems();
    }
}
