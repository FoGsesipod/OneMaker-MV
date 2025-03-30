import QtQuick 2.3
import QtQuick.Controls 1.2
import "../BasicControls"
import "../BasicLayouts"
import "../Controls"
import "../ObjControls"
import "../Singletons"

ModelessWindow {
    id: root

    title: qsTr("Event Searcher")

    property var dataObject
    property int selectedMapId: DataManager.currentMapId
    // [OneMaker MV] - Added extensive param searching system
    //readonly property var searchObj: [
    //    [[103, 104, 285], [0, 0]],  // 0: simple comparison
    //    [[311, 312, 326, 313, 314, 315, 316, 317, 318, 201, 301], [1, 0, 1, 1]],
    //    [[201], [1, 0, 1, 2]],
    //    [[201], [1, 0, 1, 3]],
    //    [[125, 202, 203], [1, 1, 1, 2]],
    //    [[202, 203], [1, 1, 1, 3]],
    //    [[202], [1, 1, 1, 4]],
    //    [[126, 127, 128, 331, 332, 342, 285], [1, 2, 1, 3]],
    //    [[285], [1, 2, 1, 4]],
    //    [[311, 312, 315, 316, 326, 231, 232], [1, 3, 1, 4]],
    //    [[231, 232], [1, 3, 1, 5]],
    //    [[317], [1, 4, 1, 5]]
    //];
    readonly property var paramSearchData: {
        // switchMode
        "2": [
            // 101 105 manual
            ["getValue", [111],
                [[0,0], 1],
            ],
            // 121 205 manual
        ],
        // variableMode
        "1": [
            // 101 105 manual
            ["setValue", [103, 104],
                [0]
            ],
            ["getValue", [111],
                [[0,1], 1],
                [[0,1], [2,1], 3],
                [[0,14], [2,1], 3], /*ex*/
            ],
            ["getValue", [122, 357 /*ex*/],
                // param 0 and 1 manual
                [[3,1], 4]
            ],
            ["getValue", [125, 126, 127, 128],
                [[1,1], 2]
            ],
            ["getValue", [201],
                [[0,1], 1],
                [[0,1], 2],
                [[0,1], 3],
            ],
            ["getValue", [202],
                [[1,1], 2],
                [[1,1], 3],
                [[1,1], 4],
            ],
            ["getValue", [203],
                [[1,1], 2],
                [[1,1], 3],
            ],
            ["getValue", [231],
                [[3,1], 4],
                [[3,1], 5],
            ],
            ["setValue", [285],
                [0],
            ],
            ["getValue", [285],
                [[2,1], 3],
                [[2,1], 4],
            ],
            ["getValue", [301, 313, 314, 318],
                [[0,1], 1],
            ],
            ["getValue", [311, 312, 326, 315, 316],
                [[3,1], 4],
                [[0,1], 1],
            ],
            ["getValue", [317],
                [[4,1], 5],
            ],
            ["getValue", [331, 332, 342],
                [[2,1], 3],
            ],
        ],
    }

    readonly property int controlSwitchCode: 121
    readonly property int controlVariableCode: 122
    // [OneMaker MV] - Removed no longer used variable
    //readonly property int conditionBranchCode: 111
    readonly property int setMovementRouteCode: 205
    // [OneMaker MV] - Added comment codes
    readonly property int commentCode: 108
    readonly property int commentDataCode: 408
    // [OneMaker MV] - Added script codes
    readonly property int scriptCode: 355
    readonly property int scriptDataCode: 655

    readonly property int variableMode: 1
    readonly property int switchMode: 2
    // [OneMaker MV] - Added new search modes
    readonly property int eventNoteMode: 3
    readonly property int commentMode: 4
    readonly property int scriptMode: 5

    DialogBox {
        id: dialog
        okVisible: false
        cancelVisible: false
        applyVisible: false
        closeVisible: true
        okEnabled: false

        onInit: {
            radioButton1.checked = true;
            root.firstFocusItem = radioButton1;
        }

        HeavyProcessTimer {
            id: heavy
        }

        Action {
            id: doSearch
            shortcut: "Return"
            onTriggered: {
                heavy.run(function() {
                    listBox.doSearch();
                });
            }
        }

        Action {
            enabled: doSearch.enabled
            shortcut: "Enter"
            onTriggered: {
                heavy.run(function() {
                    listBox.doSearch();
                });
            }
        }

        GroupBoxColumn {

            GroupBox {
                id: itemGroupBox
                title: qsTr("Search for")
                hint: qsTr("Specifies what to search for.")

                property int radioButtonWidth: 100
                property int itemHeight: 28

                ControlsColumn {
                    ExclusiveGroup { id: itemGroup }

                    ControlsRow {
                        RadioButton {
                            id: radioButton1
                            text: qsTr("Switch")
                            hint: qsTr("Search for the switch.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        GameSwitchBox {
                            member: "switchId"
                            id: switchBox
                            title: radioButton1.title
                            hint: radioButton1.hint
                            enabled: radioButton1.checked
                            labelVisible: false
                        }
                    }
                    ControlsRow {
                        RadioButton {
                            id: radioButton2
                            text: qsTr("Variable")
                            hint: qsTr("Search for the variable.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        GameVariableBox {
                            member: "variableId"
                            id: variableBox
                            title: radioButton2.title
                            hint: radioButton2.hint
                            enabled: radioButton2.checked
                            labelVisible: false
                        }
                    }
                    ControlsRow {
                        RadioButton {
                            id: radioButton3
                            text: qsTr("Event Name")
                            hint: qsTr("Search for the event name.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        TextField {
                            id: eventName
                            title: radioButton3.title
                            hint: radioButton3.hint
                            enabled: radioButton3.checked
                            width: 444

                            property bool okEnabled: true
                            function ok() {
                                heavy.run(function() {
                                    listBox.doSearch();
                                });
                            }
                        }
                    }
                    // [OneMaker MV] - Added event note search mode
                    ControlsRow {
                        RadioButton {
                            id: radioButtonEventNote
                            text: qsTr("Event Note")
                            hint: qsTr("Search for the event note.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        TextField {
                            id: eventNoteInput
                            title: radioButtonEventNote.title
                            hint: radioButtonEventNote.hint
                            enabled: radioButtonEventNote.checked
                            width: 444

                            property bool okEnabled: true
                            function ok() {
                                heavy.run(function() {
                                    listBox.doSearch();
                                });
                            }
                        }
                    }
                    // [OneMaker MV] - Added comment search mode
                    ControlsRow {
                        RadioButton {
                            id: radioButtonComment
                            text: qsTr("Comment")
                            hint: qsTr("Search for comments.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        TextField {
                            id: commentInput
                            title: radioButtonComment.title
                            hint: radioButtonComment.hint
                            enabled: radioButtonComment.checked
                            width: 444

                            property bool okEnabled: true
                            function ok() {
                                heavy.run(function() {
                                    listBox.doSearch();
                                });
                            }
                        }
                    }
                    // [OneMaker MV] - Added script search mode
                    ControlsRow {
                        RadioButton {
                            id: radioButtonScript
                            text: qsTr("Script")
                            hint: qsTr("Search for scripts.")
                            exclusiveGroup: itemGroup
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        TextField {
                            id: scriptInput
                            title: radioButtonScript.title
                            hint: radioButtonScript.hint
                            enabled: radioButtonScript.checked
                            width: 444

                            property bool okEnabled: true
                            function ok() {
                                heavy.run(function() {
                                    listBox.doSearch();
                                });
                            }
                        }
                    }
                    // [OneMaker MV] - Added options for search modes
                    ControlsRow {
                        Label {
                            // used for alignment
                            width: itemGroupBox.radioButtonWidth
                            height: itemGroupBox.itemHeight
                        }
                        Label {
                            text: "(No options)"
                            height: itemGroupBox.itemHeight
                            enabled: false
                            // TODO: make this automatic
                            visible: !optionGetValue.visible && !optionSetValue.visible && !optionTextExact.visible && !optionTextCase.visible
                        }
                        CheckBox {
                            id: optionGetValue
                            text: "Gets value"
                            hint: "Whether to match reads of the values."
                            height: itemGroupBox.itemHeight
                            checked: true
                            visible: radioButton1.checked || radioButton2.checked
                        }
                        CheckBox {
                            id: optionSetValue
                            text: "Sets value"
                            hint: "Whether to match writes to the value."
                            height: itemGroupBox.itemHeight
                            checked: true
                            visible: radioButton1.checked || radioButton2.checked
                        }
                        CheckBox {
                            id: optionTextExact
                            text: "Exact text"
                            hint: "Whether to match text exactly or to contain it."
                            height: itemGroupBox.itemHeight
                            checked: false
                            visible: radioButton3.checked || radioButtonEventNote.checked || radioButtonComment.checked || radioButtonScript.checked
                        }
                        CheckBox {
                            id: optionTextCase
                            text: "Case-sensitive"
                            hint: "Whether to match text by case."
                            height: itemGroupBox.itemHeight
                            checked: false
                            visible: radioButton3.checked || radioButtonEventNote.checked || radioButtonComment.checked || radioButtonScript.checked
                        }
                    }
                }
            }

            Button {
                text: qsTr("Search")
                hint: qsTr("Executes the search.")
                width: 120
                action: doSearch
            }

            GroupBox {
                id: resultsBox
                title: qsTr("Search Results")
                hint: qsTr("List for the search results.")
                width: parent.width
                height: 396

                ListBox {
                    id: listBox
                    title: resultsBox.title
                    hint: resultsBox.hint
                    anchors.fill: parent
                    model: ListModel {
                        id: listModel
                    }

                    function getDataArray() {
                        return [];
                    }

                    ListBoxColumn {
                        title: qsTr("Map")
                        role: "map"
                        width: 190
                    }
                    ListBoxColumn {
                        title: qsTr("Event")
                        role: "event"
                        width: 190
                    }
                    ListBoxColumn {
                        title: qsTr("Page")
                        role: "page"
                        width: 64
                    }
                    ListBoxColumn {
                        title: qsTr("Position")
                        role: "coordinate"
                        width: 92
                    }

                    function doSearch() {
                        var i, max, maps, _data;
                        var data = [];
                        var switchId = switchBox.switchId;
                        var variableId = variableBox.variableId;
                        listModel.clear();
                        currentIndex = 0;

                        // common event
                        if (radioButton1.checked) {
                            // [OneMaker MV] - Removed searchCommonEventsSwitch function to add options argument
                            //_data = root.searchCommonEventsSwitch(switchId);
                            _data = root.searchCommonEvents(switchMode, switchId, { getValue: optionGetValue.checked, setValue: optionSetValue.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        if (radioButton2.checked) {
                            // [OneMaker MV] - Removed searchCommonEventsVariable function to add options argument
                            //_data = root.searchCommonEventsVariable(variableId);
                            _data = root.searchCommonEvents(variableMode, variableId, { getValue: optionGetValue.checked, setValue: optionSetValue.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for event names
                        if (radioButton3.checked) {
                            _data = root.searchCommonEvents('', eventName.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for comments
                        if (radioButtonComment.checked) {
                            _data = root.searchCommonEvents(commentMode, commentInput.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for scripts
                        if (radioButtonScript.checked) {
                            _data = root.searchCommonEvents(scriptMode, scriptInput.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }


                        // all maps
                        DataManager.loadAllMaps();
                        maps = DataManager.getDataSet('mapInfos');
                        for (i = 1, max = maps.length; i < max; i++) {
                            if(!maps[i]) {
                                continue;
                            }
                            _searchSingleMap(maps[i].id, data, variableId, switchId);
                        }

                        for (i = data.length - 1; i >= 0; i--) {
                            listModel.insert(currentIndex, makeModelItem(data[i]));
                            currentIndex++;
                        }
                    }

                    function _searchSingleMap(mapId, data) {
                        var i, max, _data;
                        var switchId = switchBox.switchId;
                        var variableId = variableBox.variableId;
                        var name = eventName.text;
                        if (radioButton1.checked) {
                            // [OneMaker MV] - Removed searchEventsSwitch function to add options argument
                            //_data = root.searchEventsSwitch(mapId, switchId);
                            _data = root.searchEvents(mapId, switchMode, switchId, { getValue: optionGetValue.checked, setValue: optionSetValue.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        if (radioButton2.checked) {
                            // [OneMaker MV] - Removed searchEventsVariable function to add options argument
                            //_data = root.searchEventsVariable(mapId, switchId);
                            _data = root.searchEvents(mapId, variableMode, variableId, { getValue: optionGetValue.checked, setValue: optionSetValue.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        if (radioButton3.checked) {
                            // [OneMaker MV] - Removed searchEventsName function to add options argument
                            //_data = root.searchEventsName(mapId, switchId);
                            _data = root.searchEvents(mapId, '', name, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for event notes
                        if (radioButtonEventNote.checked) {
                            _data = root.searchEvents(mapId, eventNoteMode, eventNoteInput.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for comments
                        if (radioButtonComment.checked) {
                            _data = root.searchEvents(mapId, commentMode, commentInput.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                        // [OneMaker MV] - Added search for scripts
                        if (radioButtonScript.checked) {
                            _data = root.searchEvents(mapId, scriptMode, scriptInput.text, { exact: optionTextExact.checked, case: optionTextCase.checked });
                            for (i = 0, max = _data.length; i < max; i++) {
                                data.push(_data[i]);
                            }
                        }
                    }

                    function makeModelItem(data) {
                        var item = {};
                        if (data) {
                            item.map = data.map || "Common";
                            item.page = data.page || "-";
                            item.event = data.event || "";
                            item.coordinate = data.coordinate || "Common";
                        } else {
                            item.map = "";
                            item.page = "";
                            item.event = "";
                            item.coordinate = "";
                        }
                        return item;
                    }
                }
            }
        }
    }

    // [OneMaker MV] Added utility function for extensive param searching
    function searchEventParams(mode, id, cmd, options) {
        var data = paramSearchData[mode + ""] || [];
        for (var i = 0; i < data.length; i++) {
            if (data[i][0] && !options[data[i][0]])
                continue;
            if (data[i][1].indexOf(cmd.code) === -1)
                continue;
            if (searchEventParamsTests(id, cmd.parameters, data[i]))
                return true;
        }
        return false;
    }
    // [OneMaker MV] Added utility function for extensive param searching
    function searchEventParamsTests(id, params, tests) {
        l_next_test: for (var i = 2; i < tests.length; i++) {
            for (var j = 0; j < tests[i].length; j++) {
                switch (typeof tests[i][j]) {
                    case "object": // [i,j]
                        if (params[tests[i][j][0]] !== tests[i][j][1])
                            continue l_next_test;
                        break;
                    case "number": // i
                        if (params[tests[i][j][0]] !== id)
                            continue l_next_test;
                        break;
                }
            }
            return true;
        }
        return false;
    }

    // [OneMaker MV] Added utility function for text options
    function compareSearchText(text, target, options) {
        if (!options.case && options.case != null) {
            text   = text  .toLowerCase();
            target = target.toLowerCase();
        }
        if (!options.exact && options.exact != null)
            return target === "" || text.indexOf(target) !== -1;
        else
            return text === target;
    }

    function searchCommonEvents(mode, id) {
        var options = arguments[2] || {}; // [OneMaker MV] - Added options argument
        var i, max, _event;
        var commonEvents = DataManager.getDataSet('commonEvents');
        var results = [];
        for (i = 1, max = commonEvents.length; i < max; i++) {
            _event = commonEvents[i];

            // [OneMaker MV] - Added search for common event names
            // search by event name
            if (mode === '') {
                if (compareSearchText(_event.name, id, options)) {
                    results.push(_createResult('Common', '-', {}, _event));
                }
                continue;
            }

            if (!(Array.isArray(_event.list))) {
                continue;
            }
            _search({
                'event': _event,
                'list': _event.list,
                'mode': mode,
                'id': id
            }, results, options); // [OneMaker MV] - Added options argument
        }
        return results;
    }

    // [OneMaker MV] - Removed functions to add options argument.
    //function searchCommonEventsSwitch(switchId) {
    //    return searchCommonEvents(switchMode, switchId);
    //}

    //function searchCommonEventsVariable(variableId) {
    //    return searchCommonEvents(variableMode, variableId);
    //}

    function searchEvents(mapId, mode, idOrName) {
        var options = arguments[3] || {}; // [OneMaker MV] - Added options argument
        var map = DataManager.maps[mapId];
        if (!map) {
            return [];
        }
        var info = DataManager.getDataObject("mapInfos", mapId);
        var i, j, max, name, id;
        var _event;
        var results = [];
        for (i = 1, max = map.events.length; i < max; i++) {
            _event = map.events[i];
            if (!_event) {
                continue;
            }

            // search by event name
            if (mode === '') {
                name = idOrName;
                // [OneMaker MV] - Changed search for event names to use text options
                //if (_event.name === name) {
                if (compareSearchText(_event.name, name, options)) {
                    results.push(_createResult(mapId, '-', info, _event));
                }
                continue;
            }
            // [OneMaker MV] - Added search for event notes
            // search by event note
            if (mode === eventNoteMode) {
                if (compareSearchText(_event.note, idOrName, options)) {
                    results.push(_createResult(mapId, '-', info, _event));
                }
                continue;
            }

            // search by variable or switch
            id = idOrName;
            for (j = 0; j < _event.pages.length; j++) {
                _search({
                    'event': _event,
                    'list': _event.pages[j].list,
                    'mode': mode,
                    'id': id,
                    'mapId': mapId,
                    'page': (j + 1).toString(),
                    'info': info
                }, results, options); // [OneMaker MV] - Added options argument
            }
        }
        return results;
    }

    // [OneMaker MV] - Removed functions that are no longer used.
    //function searchEventsSwitch(mapId, switchId) {
    //    return searchEvents(mapId, switchMode, switchId);
    //}

    //function searchEventsVariable(mapId, variableId) {
    //    return searchEvents(mapId, variableMode, variableId);
    //}

    //function searchEventsName(mapId, name) {
    //    return searchEvents(mapId, '', name);
    //}

    function _search(eventArgs, results) {
        var options = arguments[2] || {}; // [OneMaker MV] - Added options argument
        var event = eventArgs['event'];
        var list  = eventArgs['list'];
        var mode  = eventArgs['mode'];
        var id    = eventArgs['id'];
        var page  = eventArgs['page'] || '-';
        var mapId = eventArgs['mapId'] || 'Common';
        var info  = eventArgs['info'] || {};
        var i, j, k, s, parameters, code;
        var dupulicated = false;

        // [OneMaker MV] - Added search for switches in page conditions
        if (!dupulicated && mode === switchMode && options.getValue) {
            if (page === "-") {
                if (event.trigger !== 0 && event.switchId === id) {
                    results.push(_createResult(mapId, page, info, event));
                    dupulicated = true;
                }
            } else {
                var eventPage = event.pages[page-1];
                if (eventPage.conditions.switch1Valid && eventPage.conditions.switch1Id === id ||
                    eventPage.conditions.switch2Valid && eventPage.conditions.switch2Id === id
                ) {
                    results.push(_createResult(mapId, page, info, event));
                    dupulicated = true;
                }
            }
        }
        // [OneMaker MV] - Added search for variables in page conditions
        if (!dupulicated && mode === variableMode && options.getValue) {
            if (page === "-") {
                // no var
            } else {
                var eventPage = event.pages[page-1];
                if (eventPage.conditions.variableValid && eventPage.conditions.variableId === id) {
                    results.push(_createResult(mapId, page, info, event));
                    dupulicated = true;
                }
            }
        }
        // [OneMaker MV] - Added search for script in page conditions
        if (!dupulicated && mode === scriptMode) {
            if (page === "-") {
                // no script
            } else {
                var eventPage = event.pages[page-1];
                if (eventPage.conditions.scriptValid && compareSearchText(eventPage.conditions.script, id, options)) {
                    results.push(_createResult(mapId, page, info, event));
                    dupulicated = true;
                }
            }
        }

        for (i = 0; i < list.length; i++) {
            if (dupulicated) {
                dupulicated = false;
                break;
            }

            // [OneMaker MV] - Added extensive param searching system
            if (searchEventParams(mode, id, list[i], options)) {
                results.push(_createResult(mapId, page, info, event));
                dupulicated = true;
                continue;
            }

            if (mode === switchMode) {
                // [OneMaker MV] - Removed code replaced by extensive param searching system
                //// for condition branch code
                //if (list[i].code === conditionBranchCode) {
                //    parameters = list[i].parameters;
                //    if (parameters[0] !== 0) {
                //        continue;
                //    }
                //    if (parameters[1] === id) {
                //        results.push(_createResult(mapId, page, info, event));
                //        dupulicated = true;
                //        continue;
                //    }
                //}

                // for set movement route code
                if (list[i].code === setMovementRouteCode && options.setValue) { // [OneMaker MV] - Change search for switches to use get/set options
                    parameters = list[i].parameters;
                    for (j = 0; j < parameters.length; j++) {
                        if (dupulicated) {
                            continue;
                        }
                        for (k = 0; k < parameters[1].list.length; k++) {
                            if (dupulicated) {
                                continue;
                            }
                            if (parameters[1].list[k].code === 27 ||
                            parameters[1].list[k].code === 28) {
                                if (parameters[1].list[k].parameters[0] === id) {
                                    results.push(_createResult(mapId, page, info, event));
                                    dupulicated = true;
                                    continue;
                                }
                            }
                        }
                    }
                }

                // for control
                if (list[i].code === controlSwitchCode && options.setValue) { // [OneMaker MV] - Change search for switches to use get/set options
                    parameters = list[i].parameters;
                    if (!(Array.isArray(parameters))) {
                        continue;
                    }
                    if (parameters[0] <= id && id <= parameters[1]) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }
            }

            if (mode === variableMode) {
                // [OneMaker MV] - Removed code replaced by extensive param searching system
                //// for condition branch code
                //if (list[i].code === conditionBranchCode) {
                //    parameters = list[i].parameters;
                //    if (parameters[0] !== 1) {
                //        continue;
                //    }
                //    if (parameters[1] === id) {
                //        results.push(_createResult(mapId, page, info, event));
                //        dupulicated = true;
                //        continue;
                //    }
                //    if (parameters[2] === 1 && parameters[3] === id) {
                //        results.push(_createResult(mapId, page, info, event));
                //        dupulicated = true;
                //        continue;
                //    }
                //}

                // [OneMaker MV] - Removed code replaced by extensive param searching system
                //// for searchObj
                //for (s = 0; s < searchObj.length; s++) {
                //    if (dupulicated) {
                //        continue;
                //    }
                //    if (searchObj[s][0].indexOf(list[i].code) >= 0) {
                //        parameters = list[i].parameters;
                //        // simple compare
                //        if (searchObj[s][1][0] === 0) {
                //            if (parameters[searchObj[s][1][1]] === id) {
                //                results.push(_createResult(mapId, page, info, event));
                //                dupulicated = true;
                //                continue;
                //            }
                //        }
                //        // complex compare
                //        else if (searchObj[s][1][0] === 1) {
                //            if (parameters[searchObj[s][1][1]] === searchObj[s][1][2] &&
                //            parameters[searchObj[s][1][3]] === id) {
                //                results.push(_createResult(mapId, page, info, event));
                //                dupulicated = true;
                //                continue;
                //            }
                //        }
                //    }
                //}

                // for control
                if (list[i].code === controlVariableCode && options.setValue) { // [OneMaker MV] - Change search for variables to use get/set options
                    parameters = list[i].parameters;
                    if (!(Array.isArray(parameters))) {
                        continue;
                    }
                    if (parameters[0] <= id && id <= parameters[1]) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }
            }

            // [OneMaker MV] - Added search for comments
            if (mode === commentMode) {
                // for comment
                if (list[i].code === commentCode) {
                    var blockText = list[i].parameters[0] + "\n";
                    while (list[i+1] && list[i+1].code === commentDataCode) {
                        i++;
                        blockText += list[i].parameters[0] + "\n";
                    }
                    if (compareSearchText(blockText, id, options)) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }
            }

            // [OneMaker MV] - Added search for scripts
            if (mode === scriptMode) {
                // for condition branch code
                if (list[i].code === conditionBranchCode) {
                    parameters = list[i].parameters;
                    if (parameters[0] !== 12) {
                        continue;
                    }
                    if (compareSearchText(parameters[1], id, options)) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }

                // for set movement route code
                if (list[i].code === setMovementRouteCode) {
                    parameters = list[i].parameters;
                    for (j = 0; j < parameters.length; j++) {
                        if (dupulicated) {
                            continue;
                        }
                        for (k = 0; k < parameters[1].list.length; k++) {
                            if (dupulicated) {
                                continue;
                            }
                            if (parameters[1].list[k].code === 45) {
                                if (compareSearchText(parameters[1].list[k].parameters[0], id, options)) {
                                    results.push(_createResult(mapId, page, info, event));
                                    dupulicated = true;
                                    continue;
                                }
                            }
                        }
                    }
                }

                // for control variable or self variable
                if (list[i].code === controlVariableCode ||
                    list[i].code === controlSelfVariableCode
                ) {
                    parameters = list[i].parameters;
                    if (!(Array.isArray(parameters))) {
                        continue;
                    }
                    if (parameters[3] !== 4) {
                        continue;
                    }
                    if (compareSearchText(parameters[4], id, options)) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }

                // for script
                if (list[i].code === scriptCode) {
                    var blockText = list[i].parameters[0] + "\n";
                    while (list[i+1] && list[i+1].code === scriptDataCode) {
                        i++;
                        blockText += list[i].parameters[0] + "\n";
                    }
                    if (compareSearchText(blockText, id, options)) {
                        results.push(_createResult(mapId, page, info, event));
                        dupulicated = true;
                        continue;
                    }
                }
            }
        }
        return results;
    }

    function _createResult(mapId, page, info, event) {
        var result = {
            'event': _padding3(event.id) + ':' + event.name,
            'page': page
        };
        if (mapId !== 'Common') {
            result.map = _padding3(mapId) + ':' + info.name;
            result.coordinate = '(' + event.x + ',' + event.y + ')';
        }
        return result;
    }

    function _padding3(str) {
        return ("00" + str).slice(-3)
    }
}
