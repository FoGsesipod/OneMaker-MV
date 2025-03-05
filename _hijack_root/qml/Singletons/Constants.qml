pragma Singleton
import QtQuick 2.3

QtObject {
    readonly property string applicationTitle       : qsTr("OneMaker MV") // Changed to OneMaker MV
    readonly property string projectExtName         : "rpgproject"
    readonly property string projectFilterTitle     : applicationTitle + " " + qsTr("Project")
    readonly property string projectFilter          : projectFilterTitle + " (*." + projectExtName + ")"
    readonly property string projectFileName        : "Game." + projectExtName
    readonly property string savefileExtName        : "rpgsave"

    readonly property string noteTitle              : qsTr("Note")
    readonly property string noteDesc               : qsTr("Free text notes.")
    readonly property string noteHint               : qsTr("Text area where you can freely add notes.")
    readonly property string eventImageTitle        : qsTr("Image")
    readonly property string eventImageHint         : qsTr("Image to be displayed as the event.")
    readonly property string includeEquipmentText   : qsTr("Include Equipment")
    readonly property string includeEquipmentHint1  : qsTr("Items that are equipped by party members will also be affected.")
    readonly property string includeEquipmentHint2  : qsTr("Items that are equipped by party members will also be treated as their possession.")
    readonly property string allowKnockoutText      : qsTr("Allow Knockout")
    readonly property string allowKnockoutHint      : qsTr("Allows HP to drop to 0. If unchecked, stops at 1 HP.")
    readonly property string showLevelUpText        : qsTr("Show Level Up")
    readonly property string showLevelUpHint        : qsTr("Displays a message upon leveling up.")
    readonly property string loopHorizontally       : qsTr("Loop Horizontally")
    readonly property string loopVertically         : qsTr("Loop Vertically")
    readonly property string faceImageTitle         : qsTr("Face", "Face Image")
    readonly property string faceImageHint          : qsTr("Image to be displayed on the menu screen.")
    readonly property string characterImageTitle    : qsTr("Character", "Character Image")
    readonly property string characterImageHint     : qsTr("Image to be displayed on the map screen.")
    readonly property string battlerImageTitle      : qsTr("[SV] Battler", "[SV] Battler Image")
    readonly property string battlerImageHint       : qsTr("Image to be displayed in battle when in side-view mode.")

    readonly property string invalidDataName        : "?"

    readonly property int _TRAIT_ELEMENT_RATE      : 11
    readonly property int _TRAIT_DEBUFF_RATE       : 12
    readonly property int _TRAIT_STATE_RATE        : 13
    readonly property int _TRAIT_STATE_RESIST      : 14
    readonly property int _TRAIT_PARAM             : 21
    readonly property int _TRAIT_XPARAM            : 22
    readonly property int _TRAIT_SPARAM            : 23
    readonly property int _TRAIT_ATK_ELEMENT       : 31
    readonly property int _TRAIT_ATK_STATE         : 32
    readonly property int _TRAIT_ATK_SPEED         : 33
    readonly property int _TRAIT_ATK_TIMES         : 34
    readonly property int _TRAIT_STYPE_ADD         : 41
    readonly property int _TRAIT_STYPE_SEAL        : 42
    readonly property int _TRAIT_SKILL_ADD         : 43
    readonly property int _TRAIT_SKILL_SEAL        : 44
    readonly property int _TRAIT_EQUIP_WTYPE       : 51
    readonly property int _TRAIT_EQUIP_ATYPE       : 52
    readonly property int _TRAIT_EQUIP_LOCK        : 53
    readonly property int _TRAIT_EQUIP_SEAL        : 54
    readonly property int _TRAIT_SLOT_TYPE         : 55
    readonly property int _TRAIT_ACTION_PLUS       : 61
    readonly property int _TRAIT_SPECIAL_FLAG      : 62
    readonly property int _TRAIT_COLLAPSE_TYPE     : 63
    readonly property int _TRAIT_PARTY_ABILITY     : 64

    readonly property int _EFFECT_RECOVER_HP       : 11
    readonly property int _EFFECT_RECOVER_MP       : 12
    readonly property int _EFFECT_GAIN_TP          : 13
    readonly property int _EFFECT_ADD_STATE        : 21
    readonly property int _EFFECT_REMOVE_STATE     : 22
    readonly property int _EFFECT_ADD_BUFF         : 31
    readonly property int _EFFECT_ADD_DEBUFF       : 32
    readonly property int _EFFECT_REMOVE_BUFF      : 33
    readonly property int _EFFECT_REMOVE_DEBUFF    : 34
    readonly property int _EFFECT_SPECIAL          : 41
    readonly property int _EFFECT_GROW             : 42
    readonly property int _EFFECT_LEARN_SKILL      : 43
    readonly property int _EFFECT_COMMON_EVENT     : 44

    readonly property int troopScreenWidth      : 816
    readonly property int troopScreenHeight     : 444
    readonly property int troopGridSize         : 16

    readonly property int animationScreenWidth  : 816
    readonly property int animationScreenHeight : 624
    readonly property int animationPatternSize  : 192
    readonly property int animationGridSize     : 16

    readonly property int tilesetEditPick       : -1
    readonly property int tilesetEditPassage    : 0
    readonly property int tilesetEditPassage4   : 1
    readonly property int tilesetEditLadder     : 2
    readonly property int tilesetEditBush       : 3
    readonly property int tilesetEditCounter    : 4
    readonly property int tilesetEditDamage     : 5
    readonly property int tilesetEditTerrain    : 6

    readonly property string playerName     : qsTr("Player")
    readonly property string boatName       : qsTr("Boat")
    readonly property string shipName       : qsTr("Ship")
    readonly property string airshipName    : qsTr("Airship")
    readonly property string thisEventName  : qsTr("This Event")

    readonly property int mhpIndex: 0
    readonly property int mmpIndex: 1
    readonly property int atkIndex: 2
    readonly property int defIndex: 3
    readonly property int matIndex: 4
    readonly property int mdfIndex: 5
    readonly property int agiIndex: 6
    readonly property int lukIndex: 7
    readonly property int patamMax: 8

    readonly property string hpName : qsTr("HP")
    readonly property string mpName : qsTr("MP")
    readonly property string tpName : qsTr("TP")
    readonly property string levelName : qsTr("Level")
    readonly property string expName : qsTr("EXP")

    readonly property string mhpName: qsTr("Max HP")
    readonly property string mmpName: qsTr("Max MP")
    readonly property string atkName: qsTr("Attack")
    readonly property string defName: qsTr("Defense")
    readonly property string matName: qsTr("M.Attack")
    readonly property string mdfName: qsTr("M.Defense")
    readonly property string agiName: qsTr("Agility")
    readonly property string lukName: qsTr("Luck")

    readonly property string hitName: qsTr("Hit Rate")
    readonly property string evaName: qsTr("Evasion Rate")
    readonly property string criName: qsTr("Critical Rate")
    readonly property string cevName: qsTr("Critical Evasion")
    readonly property string mevName: qsTr("Magic Evasion")
    readonly property string mrfName: qsTr("Magic Reflection")
    readonly property string cntName: qsTr("Counter Attack")
    readonly property string hrgName: qsTr("HP Regeneration")
    readonly property string mrgName: qsTr("MP Regeneration")
    readonly property string trgName: qsTr("TP Regeneration")

    readonly property string tgrName: qsTr("Target Rate")
    readonly property string grdName: qsTr("Guard Effect")
    readonly property string recName: qsTr("Recovery Effect")
    readonly property string phaName: qsTr("Pharmacology")
    readonly property string mcrName: qsTr("MP Cost Rate")
    readonly property string tcrName: qsTr("TP Charge Rate")
    readonly property string pdrName: qsTr("Physical Damage")
    readonly property string mdrName: qsTr("Magical Damage")
    readonly property string fdrName: qsTr("Floor Damage")
    readonly property string exrName: qsTr("Experience")

    readonly property string mhpHint: qsTr("Maximum hit point. Represents the maximum amount of damage that the character can withstand.")
    readonly property string mmpHint: qsTr("Maximum magic point. Represents the character's maximum power for using magic skills.")
    readonly property string atkHint: qsTr("Attack power. Affects things like the amount of damage done to opponents.")
    readonly property string defHint: qsTr("Defense power. Affects things like the amount of damage taken from opponents.")
    readonly property string matHint: qsTr("Magic attack power. Affects things like the power of the magic the character uses.")
    readonly property string mdfHint: qsTr("Magic defense power. Affects things like the power of magic attacks from opponents.")
    readonly property string agiHint: qsTr("Agility. Affects things like attack order.")
    readonly property string lukHint: qsTr("Luck. Affects things like the chance of status ailments occurring.")

    readonly property color mhpColor: "#D08060"
    readonly property color mmpColor: "#5080E0"
    readonly property color atkColor: "#C04060"
    readonly property color defColor: "#90B060"
    readonly property color matColor: "#C050B0"
    readonly property color mdfColor: "#40A040"
    readonly property color agiColor: "#50B0E0"
    readonly property color lukColor: "#D0B040"

    readonly property string commandFight:      qsTr("Fight", "command")
    readonly property string commandEscape:     qsTr("Escape", "command")
    readonly property string commandAttack:     qsTr("Attack", "command")
    readonly property string commandGuard:      qsTr("Guard", "command")
    readonly property string commandItem:       qsTr("Item", "command")
    readonly property string commandSkill:      qsTr("Skill", "command")
    readonly property string commandEquip:      qsTr("Equip", "command")
    readonly property string commandStatus:     qsTr("Status", "command")
    readonly property string commandFormation:  qsTr("Formation", "command")
    readonly property string commandOptions:    qsTr("Options", "command")
    readonly property string commandSave:       qsTr("Save", "command")
    readonly property string commandGameEnd:    qsTr("Game End", "command")
    readonly property string commandWeapon:     qsTr("Weapon", "command")
    readonly property string commandArmor:      qsTr("Armor", "command")
    readonly property string commandKeyItem:    qsTr("Key Item", "command")
    readonly property string commandEquip2:     qsTr("Equip", "command: change equip")
    readonly property string commandOptimize:   qsTr("Optimize", "command: best equip")
    readonly property string commandClear:      qsTr("Clear", "command: remove all")
    readonly property string commandBuy:        qsTr("Buy", "command")
    readonly property string commandSell:       qsTr("Sell", "command")
    readonly property string commandNewGame:    qsTr("New Game", "command")
    readonly property string commandContinue:   qsTr("Continue", "command")
    readonly property string commandToTitle:    qsTr("To Title", "command")
    readonly property string commandCancel:     qsTr("Cancel", "command")

    readonly property var paramNameArray: [
        mhpName, mmpName, atkName, defName, matName, mdfName, agiName, lukName
    ]
    readonly property var paramHintArray: [
        mhpHint, mmpHint, atkHint, defHint, matHint, mdfHint, agiHint, lukHint
    ]
    readonly property var xparamNameArray: [
        hitName, evaName, criName, cevName, mevName, mrfName, cntName, hrgName, mrgName, trgName
    ]
    readonly property var sparamNameArray: [
        tgrName, grdName, recName, phaName, mcrName, tcrName, pdrName, mdrName, fdrName, exrName
    ]
    readonly property var paramColorArray: [
        mhpColor, mmpColor, atkColor, defColor, matColor, mdfColor, agiColor, lukColor
    ]
    readonly property var paramMinArray: [
        1, 0, 1, 1, 1, 1, 1, 1
    ]
    readonly property var paramMaxArray: [
        9999, 9999, 999, 999, 999, 999, 999, 999
    ]
    readonly property var paramGraphMaxArray: [
        9999, 2000, 250, 250, 250, 250, 500, 500
    ]
    readonly property var scopeArray: [
        qsTr("None"), qsTr("1 Enemy"), qsTr("All Enemies"), qsTr("1 Random Enemy"),
        qsTr("2 Random Enemies"), qsTr("3 Random Enemies"), qsTr("4 Random Enemies"), qsTr("1 Ally"),
        qsTr("All Allies"), qsTr("1 Ally (Dead)"), qsTr("All Allies (Dead)"), qsTr("The User")
    ]
    readonly property var occasionArray: [
        qsTr("Always"), qsTr("Battle Screen"), qsTr("Menu Screen"), qsTr("Never")
    ]
    readonly property var itemTypeArray: [
        qsTr("Regular Item"), qsTr("Key Item"), qsTr("Hidden Item A"), qsTr("Hidden Item B")
    ]
    readonly property var slotTypeArray: [
        qsTr("Normal"), qsTr("Dual Wield")
    ]
    readonly property var specialFlagArray: [
        qsTr("Auto Battle"), qsTr("Guard"), qsTr("Substitute"), qsTr("Preserve TP")
    ]
    readonly property var collapseTypeArray: [
        qsTr("Normal"), qsTr("Boss"), qsTr("Instant"), qsTr("No Disappear")
    ]
    readonly property var partyAbilityArray: [
        qsTr("Encounter Half"), qsTr("Encounter None"), qsTr("Cancel Surprise"),
        qsTr("Raise Preemptive"), qsTr("Gold Double"), qsTr("Drop Item Double")
    ]
    readonly property var specialEffectArray: [
        qsTr("Escape")
    ]
    readonly property var cellPropertyNameArray: [
        qsTr("Pattern"), qsTr("X"), qsTr("Y"), qsTr("Scale"),
        qsTr("Rotation"), qsTr("Mirror"), qsTr("Opacity"), qsTr("Blend", "Blend Mode"),
    ]
    readonly property var cellPropertyHintArray: [
        qsTr("Pattern number assigned to the cell."),
        qsTr("X coordinate of the cell."),
        qsTr("Y coordinate of the cell."),
        qsTr("Scale of the cell."),
        qsTr("Angle of rotation in degrees."),
        qsTr("Whether to draw the cell flipped horizontally."),
        qsTr("Opacity level of the cell."),
        qsTr("Blend mode used when the cell is drawn."),
    ]
    readonly property var blendModeArray: [
        qsTr("Normal", "Normal blending"),
        qsTr("Additive", "Additive blending"),
        qsTr("Multiply", "Multiply blending"),
        qsTr("Screen", "Screen blending"),
    ]
    readonly property var messageBackgroundArray: [
        qsTr("Window"), qsTr("Dim"), qsTr("Transparent")
    ]
    readonly property var messagePositionTypeArray: [
        qsTr("Top", "Vertical"), qsTr("Middle", "Vertical"),
        qsTr("Bottom", "Vertical")
    ]
    readonly property var choicesPositionTypeArray: [
        qsTr("Left", "Horizontal"), qsTr("Middle", "Horizontal"),
        qsTr("Right", "Horizontal")
    ]
    readonly property var choicesDefaultTypeArray: [
        qsTr("None"), qsTr("Choice #1"), qsTr("Choice #2"), qsTr("Choice #3"),
        qsTr("Choice #4"), qsTr("Choice #5"), qsTr("Choice #6")
    ]
    readonly property var choicesCancelTypeArray: [
        qsTr("Branch"), qsTr("Disallow"), qsTr("Choice #1"), qsTr("Choice #2"),
        qsTr("Choice #3"), qsTr("Choice #4"), qsTr("Choice #5"), qsTr("Choice #6")
    ]
    readonly property var flagOnOffArray: [
        qsTr("ON"), qsTr("OFF")
    ]
    readonly property var vehicleNameArray: [
        boatName, shipName, airshipName
    ]
    readonly property var variableActorStatusDataArray: [
        levelName, expName,
        hpName, mpName, mhpName, mmpName, atkName,
        defName, matName, mdfName, agiName, lukName
    ]
    readonly property var variableEnemyStatusDataArray: [
        hpName, mpName, mhpName, mmpName, atkName,
        defName, matName, mdfName, agiName, lukName
    ]
    readonly property var variableCharacterDataArray: [
        qsTr("Map X"), qsTr("Map Y"), qsTr("Direction"),
        qsTr("Screen X"), qsTr("Screen Y")
    ]
    readonly property var variableOtherDataArray: [
        qsTr("Map ID"), qsTr("Party Members", "Number of Party Members"),
        qsTr("Gold"), qsTr("Steps"), qsTr("Play Time"), qsTr("Timer"),
        qsTr("Save Count"), qsTr("Battle Count"), qsTr("Win Count"),
        qsTr("Escape Count")
    ]
    readonly property var fadeTypeArray: [
        qsTr("Black", "Fade to Black"), qsTr("White", "Fade to White"),
        qsTr("None", "No Fade")
    ]
    readonly property var balloonTypeArray: [
        qsTr("Exclamation"), qsTr("Question"), qsTr("Music Note"),
        qsTr("Heart"), qsTr("Anger"), qsTr("Sweat"), qsTr("Cobweb"),
        qsTr("Silence"), qsTr("Light Bulb"), qsTr("Zzz"),
        qsTr("User-defined 1"), qsTr("User-defined 2"), qsTr("User-defined 3"),
        qsTr("User-defined 4"), qsTr("User-defined 5")
    ]
    readonly property var pictureOriginTypeArray: [
        qsTr("Upper Left"), qsTr("Center")
    ]
    readonly property var locationInfoTypeArray: [
        qsTr("Terrain Tag"), qsTr("Event ID"),
        qsTr("Tile ID (Layer 1)"), qsTr("Tile ID (Layer 2)"),
        qsTr("Tile ID (Layer 3)"), qsTr("Tile ID (Layer 4)"),
        qsTr("Region ID"),
    ]
    // ==, >=, <=, >, <, !=
    readonly property var variableConditionOperatorArray: [
        qsTr("="), qsTr("\u2265"), qsTr("\u2264"),
        qsTr(">"), qsTr("<"), qsTr("\u2260")
    ]
    // >=, <=
    readonly property var timerConditionOperatorArray: [
        qsTr("\u2265"), qsTr("\u2264")
    ]
    // >=, <=, <
    readonly property var goldConditionOperatorArray: [
        qsTr("\u2265"), qsTr("\u2264"), qsTr("<")
    ]
    readonly property var directionNameArray: [
        qsTr("Down"), qsTr("Left"), qsTr("Right"), qsTr("Up")
    ]
    readonly property var directionNameArrayForTransfer: [
        qsTr("Retain"), qsTr("Down"), qsTr("Left"), qsTr("Right"), qsTr("Up")
    ]
    readonly property var weatherNameArray: [
        "none", "rain", "storm", "snow"
    ]
    readonly property var weatherNameTextArray: [
        qsTr("None"), qsTr("Rain"), qsTr("Storm"), qsTr("Snow")
    ]
    readonly property var buttonNameArray: [
        "ok", "cancel", "shift", "down", "left", "right", "up", "pageup", "pagedown"
    ]
    readonly property var buttonNameTextArray: [
        qsTr("OK", "Button"), qsTr("Cancel", "Button"), qsTr("Shift", "Button"),
        qsTr("Down", "Button"), qsTr("Left", "Button"), qsTr("Right", "Button"),
        qsTr("Up", "Button"), qsTr("Pageup", "Button"), qsTr("Pagedown", "Button")
    ]
    readonly property var attackMotionTypeArray: [
        qsTr("Thrust", "Bare hands, glove and spear"),
        qsTr("Swing", "Short-range Weapon"),
        qsTr("Missile", "Long-range Weapon")
    ]
    readonly property var weaponImageArray: [
        qsTr("None"), qsTr("Dagger"), qsTr("Sword"), qsTr("Flail"), qsTr("Axe"),
        qsTr("Whip"), qsTr("Cane"), qsTr("Bow"), qsTr("Crossbow"), qsTr("Gun"),
        qsTr("Claw"), qsTr("Glove"), qsTr("Spear"), qsTr("Mace"), qsTr("Rod"),
        qsTr("Club"), qsTr("Combat Chain"), qsTr("Futuristic Sword"),
        qsTr("Iron pipe"), qsTr("Slingshot"), qsTr("Shotgun"), qsTr("Rifle"),
        qsTr("Chainsaw"), qsTr("Railgun"), qsTr("Stun Rod"),
        qsTr("User-defined 1"), qsTr("User-defined 2"), qsTr("User-defined 3"),
        qsTr("User-defined 4"), qsTr("User-defined 5"), qsTr("User-defined 6")
    ]
    readonly property var themeNameArray: [
        "default", "dark", "highContrastWhite", "highContrastBlack"
    ]
    readonly property var themeNameTextArray: [
        qsTr("Default", "Theme"),
        qsTr("Dark", "Theme"),
        qsTr("High Contrast White", "Theme"),
        qsTr("High Contrast Black", "Theme")
    ]

    readonly property var objectSelectorArray: [
        "dropdown", "extended", "smart"
    ]
    readonly property var objectSelectorTextArray: [
        qsTr("Dropdown", "Object Selector"),
        qsTr("Extended", "Object Selector"),
        qsTr("Smart", "Object Selector"),
    ]

    readonly property var matchingTypeArray: [
        "partial", "word", "full", "regex"
    ]
    readonly property var matchingTypeTextArray: [
        qsTr("Partial Match", "Matching Type"),
        qsTr("Word Match", "Matching Type"),
        qsTr("Full Match", "Matching Type"),
        qsTr("Regular Expression", "Matching Type"),
    ]

    function framesText(param) {
        return param + (param > 1 ? qsTr(" frames") : qsTr(" frame"))
    }

    function secondsText(param) {
        return param + (param > 1 ? qsTr(" seconds") : qsTr(" second"))
    }

    function parentheses(text) {
        return "(" + text + ")";
    }

    function imageText(name, index) {
        if (name.length) {
            if (index !== undefined) {
                return "%1(%2)".arg(name).arg(index);
            } else {
                return name;
            }
        } else {
            return qsTr("None");
        }
    }

    function dualImageText(name1, name2) {
        var text = name1;
        if (name2.length) {
            if (text.length) {
                text += " "
            }
            text += "& " + name2;
        }
        if (text.length) {
            return text;
        } else {
            return qsTr("None");
        }
    }

    function audioText(param) {
        if (param.name.length) {
            var options = param.volume;
            options += ", " + param.pitch;
            options += ", " + (param.pan || 0);
            return param.name + " " + parentheses(options);
        } else {
            return qsTr("None");
        }
    }

    function movieText(name) {
        if (name.length) {
            return name;
        } else {
            return qsTr("None");
        }
    }

    function paramName(index) {
        var name = paramNameArray[index]
        return name ? name : invalidDataName;
    }

    function xparamName(index) {
        var name = xparamNameArray[index]
        return name ? name : invalidDataName;
    }

    function sparamName(index) {
        var name = sparamNameArray[index]
        return name ? name : invalidDataName;
    }

    function slotTypeName(index) {
        var name = slotTypeArray[index]
        return name ? name : invalidDataName;
    }

    function specialFlagName(index) {
        var name = specialFlagArray[index]
        return name ? name : invalidDataName;
    }

    function collapseTypeName(index) {
        var name = collapseTypeArray[index]
        return name ? name : invalidDataName;
    }

    function partyAbilityName(index) {
        var name = partyAbilityArray[index]
        return name ? name : invalidDataName;
    }

    function specialEffectName(index) {
        var name = specialEffectArray[index]
        return name ? name : invalidDataName;
    }

    function flagOnOff(index) {
        var name = flagOnOffArray[index]
        return name ? name : invalidDataName;
    }

    function vehicleName(index) {
        var name = vehicleNameArray[index]
        return name ? name : invalidDataName;
    }

    function actionTargetName(targetIndex) {
        if (targetIndex <= -2) {
            return qsTr("Last Target");
        } else if (targetIndex === -1) {
            return qsTr("Random");
        } else {
            return qsTr("Index ") + (targetIndex + 1);
        }
    }

    function variableConditionOperator(index) {
        var name = variableConditionOperatorArray[index]
        return name ? name : invalidDataName;
    }

    function timerConditionOperator(index) {
        var name = timerConditionOperatorArray[index]
        return name ? name : invalidDataName;
    }

    function goldConditionOperator(index) {
        var name = goldConditionOperatorArray[index]
        return name ? name : invalidDataName;
    }

    function directionName(direction) {
        var index = directionNameIndex(direction);
        var name = directionNameArray[index]
        return name ? name : invalidDataName;
    }

    function directionNameIndex(direction) {
        switch (direction) {
        case 2:
            return 0;
        case 4:
            return 1;
        case 6:
            return 2;
        case 8:
            return 3;
        default:
            return -1;
        }
    }

    function directionNameIndexForTransfer(direction) {
        return directionNameIndex(direction) + 1;
    }

    function directionValue(directionName) {
        var index = directionNameArray.indexOf(directionName);
        return index >= 0 ? index * 2 + 2 : 0;
    }

    function weatherIndex(weatherName) {
        return weatherNameArray.indexOf(weatherName);
    }

    function weatherNameText(weatherName) {
        var index = weatherIndex(weatherName);
        var text = weatherNameTextArray[index];
        return text ? text : invalidDataName;
    }

    function buttonIndex(buttonName) {
        return buttonNameArray.indexOf(buttonName);
    }

    function buttonNameText(buttonName) {
        var index = buttonIndex(buttonName);
        var text = buttonNameTextArray[index];
        return text ? text : invalidDataName;
    }

    function themeIndex(themeName) {
        return themeNameArray.indexOf(themeName);
    }

    function objectSelectorIndex(objectSelectorName) {
        return objectSelectorArray.indexOf(objectSelectorName);
    }

    function matchingTypeIndex(matchingTypeName) {
        return matchingTypeArray.indexOf(matchingTypeName);
    }
}
