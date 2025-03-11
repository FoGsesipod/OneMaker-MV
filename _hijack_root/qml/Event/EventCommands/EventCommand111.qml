import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Conditional Branch
EventCommandBase {
    id: root

    property int eventCodeIf:   111
    property int eventCodeElse: 411
    property int eventCodeEnd:  412

    property int radioButtonWidth: 120
    property int radioButtonHeight: 28

    TabView {
        id: tabView
        width: 460
        height: 300 + 50 // [OneMaker MV] - added + 50

        ExclusiveGroup {
            id: conditionTypeGroup
        }
        Tab_ConditionalBranch1 {
            id: tab1
            title: " 1 "
            exclusiveGroup: conditionTypeGroup
            radioButtonWidth: root.radioButtonWidth
            radioButtonHeight: root.radioButtonHeight
        }
        Tab_ConditionalBranch2 {
            id: tab2
            title: " 2 "
            exclusiveGroup: conditionTypeGroup
            radioButtonWidth: root.radioButtonWidth
            radioButtonHeight: root.radioButtonHeight
        }
        Tab_ConditionalBranch3 {
            id: tab3
            title: " 3 "
            exclusiveGroup: conditionTypeGroup
            radioButtonWidth: root.radioButtonWidth
            radioButtonHeight: root.radioButtonHeight
            troopId: root.troopId
        }
        Tab_ConditionalBranch4 {
            id: tab4
            title: " 4 "
            exclusiveGroup: conditionTypeGroup
            radioButtonWidth: root.radioButtonWidth
            radioButtonHeight: root.radioButtonHeight
        }
    }

    CheckBox {
        id: checkBox
        text: qsTr("Create Else Branch")
        hint: qsTr("Also creates a branch for when the condition is not met.")
    }

    onLoad: {
        if (eventData) {
            var command = eventData[0];
            var params = command.parameters;
            var type = params[0];
            if (type >= 0 && type <= 3 || type === 14) { // [OneMaker MV] - Added check for type 14
                tabView.currentIndex = 0;
                tab1.loadParameters(params);
            } else if (type === 4) {
                tabView.currentIndex = 1;
                tab2.loadParameters(params);
            } else if (type === 5 || type === 6 || type === 13) {
                tabView.currentIndex = 2;
                tab3.loadParameters(params);
            } else if (type >= 7 && type <= 12) {
                tabView.currentIndex = 3;
                tab4.loadParameters(params);
            }
            checkBox.checked = hasElseBranch();
        }
        firstFocusItem = conditionTypeGroup.current;
    }

    onSave: {
        var blockArray = makeBlockArray();
        var topIndent = getTopIndent();
        var createElse = checkBox.checked;
        eventData = [];
        eventData.push(makeCommand(eventCodeIf, topIndent, makeParameters()));
        eventData = eventData.concat(blockArray[0]);
        if (createElse) {
            eventData.push(makeCommand(eventCodeElse, topIndent, []));
            eventData = eventData.concat(blockArray[1]);
        }
        eventData.push(makeCommand(eventCodeEnd, topIndent, []));
    }

    function hasElseBranch() {
        if (eventData) {
            var topIndent = getTopIndent();
            for (var i = 0; i < eventData.length; i++) {
                var command = eventData[i];
                if (command.indent === topIndent && command.code === eventCodeElse) {
                    return true;
                }
            }
        }
        return false;
    }

    function makeBlockArray() {
        var blockArray = [[], []];
        var blockIndex = 0;
        var topIndent = getTopIndent();
        if (eventData) {
            for (var i = 0; i < eventData.length; i++) {
                var command = eventData[i];
                if (command.indent === topIndent) {
                    if (command.code === eventCodeElse) {
                        blockIndex = 1;
                    }
                } else {
                    blockArray[blockIndex].push(command);
                }
            }
        }
        for (var j = 0; j < blockArray.length; j++) {
            if (blockArray[j].length === 0) {
                blockArray[j].push(makeNullCommand(topIndent + 1));
            }
        }
        return blockArray;
    }

    function makeParameters() {
        var type = conditionTypeGroup.current.value;
        if (type >= 0 && type <= 3 || type === 14) { // [OneMaker MV] - Added check for type 14
            return tab1.makeParameters();
        } else if (type === 4) {
            return tab2.makeParameters();
        } else if (type === 5 || type === 6 || type === 13) {
            return tab3.makeParameters();
        } else if (type >= 7 && type <= 12) {
            return tab4.makeParameters();
        } else {
            console.warn("Unknown condition type: " + type);
            return [];
        }
    }
}
