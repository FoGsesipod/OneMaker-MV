//==============================================================================================================
// FoGsesipod - OneMaker MV Core
// OneMakerMV-Core.js
//==============================================================================================================

//onemaker-bundletool-special: 100

//==============================================================================================================
/*:
 * @plugindesc Core functionality for OneMakerMV
 * @author FoGsesipod | Sound
 * @help
 * ==============================================================================================================
 * Adds core changes necessary for features that OneMaker MV adds.
 * ==============================================================================================================
 * 
 * List of current additional feature:
 * - SelfVariable class necessary for using Self Variables.
 * - Modifies event page meetsConditions to allow Script Page Condition.
 * - Modifies troop Page meetsConditions for additional Conditions.
 * - Increases the maximun parameters for enemies.
 * - Adds Game_Interpreter command 1002, Sound Manager.
 * - Adds Game_Interpreter commands 358 and 658, Switch Statement and Case.
 * 
 * ==============================================================================================================
 * Version History:
 * ==============================================================================================================
 * 
 * 1.0.0 - Initial Release.
 * 
*/
//===============================================================================================================

// region Core Functions

if (!window.OneMakerMVCoreLoaded) {
window.OneMakerMVCoreLoaded = true

//-----------------------------------------------------------------------------
// DataManager
//
// The static class that manages the database and game objects.

var $gameSelfVariables = null;

DataManager.createGameObjects = function() {
    $gameTemp          = new Game_Temp();
    $gameSystem        = new Game_System();
    $gameScreen        = new Game_Screen();
    $gameTimer         = new Game_Timer();
    $gameMessage       = new Game_Message();
    $gameSwitches      = new Game_Switches();
    $gameVariables     = new Game_Variables();
    $gameSelfSwitches  = new Game_SelfSwitches();
    $gameSelfVariables = new Game_SelfVariables();
    $gameActors        = new Game_Actors();
    $gameParty         = new Game_Party();
    $gameTroop         = new Game_Troop();
    $gameMap           = new Game_Map();
    $gamePlayer        = new Game_Player();
};

DataManager.makeSaveContents = function() {
  // A save data does not contain $gameTemp, $gameMessage, and $gameTroop.
  var contents = {};
  contents.system       = $gameSystem;
  contents.screen       = $gameScreen;
  contents.timer        = $gameTimer;
  contents.switches     = $gameSwitches;
  contents.variables    = $gameVariables;
  contents.selfSwitches = $gameSelfSwitches;
  contents.selfVariables = $gameSelfVariables;
  contents.actors       = $gameActors;
  contents.party        = $gameParty;
  contents.map          = $gameMap;
  contents.player       = $gamePlayer;
  return contents;
};

DataManager.extractSaveContents = function(contents) {
  $gameSystem        = contents.system;
  $gameScreen        = contents.screen;
  $gameTimer         = contents.timer;
  $gameSwitches      = contents.switches;
  $gameVariables     = contents.variables;
  $gameSelfSwitches  = contents.selfSwitches;
  $gameSelfVariables = contents.selfVariables || new Game_SelfVariables();
  $gameActors        = contents.actors;
  $gameParty         = contents.party;
  $gameMap           = contents.map;
  $gamePlayer        = contents.player;
};

//-----------------------------------------------------------------------------
// Game_SelfVariables
//
// The game object class for self variables.

function Game_SelfVariables() {
  this.initialize.apply(this, arguments);
}

Game_SelfVariables.prototype.initialize = function() {
  this.clear();
};

Game_SelfVariables.prototype.clear = function() {
  this._data = {};
};

Game_SelfVariables.prototype.value = function(key) {
  return this._data[key] || 0;
};

Game_SelfVariables.prototype.setValue = function(key, value) {
  if (value) {
      if (typeof value === 'number') {
          value = Math.floor(value);
      }
      this._data[key] = value;
  } else {
      delete this._data[key];
  }
  this.onChange();
};

Game_SelfVariables.prototype.onChange = function() {
  $gameMap.requestRefresh();
};

//-----------------------------------------------------------------------------
// Game_Map
//
// The game object class for a map. It contains scrolling and passage
// determination functions.

Game_Map.prototype.selfVariableValue = function(variableId) {
  return this._interpreter.selfVariableValue(variableId);
};

//-----------------------------------------------------------------------------
// Game_Event
//
// The game object class for an event. It contains functionality for event page
// switching and running parallel process events.

Game_Event.prototype.meetsConditions = function (page) {
  var c = page.conditions;
  if (c.switch1Valid) {
      if (!$gameSwitches.value(c.switch1Id)) {
          return false;
      }
  }
  if (c.switch2Valid) {
      if (!$gameSwitches.value(c.switch2Id)) {
          return false;
      }
  }
  if (c.variableValid) {
      switch (c.variableOperator) {
        case 0: // Greater than or Equal to
            if ($gameVariables.value(c.variableId) < c.variableValue) {
                return false;
            }
            break;
        case 1: // Greater than
            if ($gameVariables.value(c.variableId) <= c.variableValue) {
                return false;
            }
            break;
        case 2: // Equal to
            if ($gameVariables.value(c.variableId) != c.variableValue) {
                return false;
            }
            break;
        case 3: // Less than
            if ($gameVariables.value(c.variableId) >= c.variableValue) {
                return false;
            }
            break;
        case 4: // Less than or Equal to
            if ($gameVariables.value(c.variableId) > c.variableValue) {
                return false;
            }
            break;
        case 5: // Not Equals to
            if ($gameVariables.value(c.variableId) === c.variableValue) {
                return false;
            }
            break;
        default: // Compatibility with MV BASE defaults to Greater than or equal to
            if ($gameVariables.value(c.variableId) < c.variableValue) {
                return false;
            }
            break;
          }
  }
  if (c.selfSwitchValid) {
      var key = [this._mapId, this._eventId, c.selfSwitchCh];
      if ($gameSelfSwitches.value(key) !== true) {
          return false;
      }
  }
  if (c.selfVariableValid) {
      var key = [this._mapId, this._eventId, c.selfVariableId ? c.selfVariableId : 0];
      if (!c.selfVariableValue) {c.selfVariableValue = 0;};
      switch (c.selfVariableOperator) {
        case 0: // Greater than or Equal to
            if ($gameSelfVariables.value(key) < c.selfVariableValue) {
                return false;
            }
            break;
        case 1: // Greater than
            if ($gameSelfVariables.value(key) <= c.selfVariableValue) {
                return false;
            }
            break;
        case 2: // Equal to
            if ($gameSelfVariables.value(key) != c.selfVariableValue) {
                return false;
            }
            break;
        case 3: // Less than
            if ($gameSelfVariables.value(key) >= c.selfVariableValue) {
                return false;
            }
            break;
        case 4: // Less than or Equal to
            if ($gameSelfVariables.value(key) > c.selfVariableValue) {
                return false;
            }
            break;
        case 5: // Not Equals to
            if ($gameSelfVariables.value(key) === c.selfVariableValue) {
                return false;
            }
            break;
        default: // Default to Greater than or Equal to
            if ($gameSelfVariables.value(key) < c.selfVariableValue) {
                return false;
            }
            break;
      }
  }
  if (c.itemValid) {
      var item = $dataItems[c.itemId];
      if (!$gameParty.hasItem(item)) {
          return false;
      }
  }
  if (c.actorValid) {
      var actor = $gameActors.actor(c.actorId);
      if (!$gameParty.members().contains(actor)) {
          return false;
      }
  }
  if (c.scriptValid) {
      try {
          var run = false;
          var script = eval(c.script);
          if (!run) {
              return false;
          }
      } catch (e) {
          SceneManager.onError(e);
          return false;
      }
  }
  return true;
};

//-----------------------------------------------------------------------------
// Game_Interpreter
//
// The interpreter for running event commands.

// Conditional Branch
Game_Interpreter.prototype.command111 = function() {
  var result = false;
  switch (this._params[0]) {
      case 0:  // Switch
          result = ($gameSwitches.value(this._params[1]) === (this._params[2] === 0));
          break;
      case 1:  // Variable
          var value1 = $gameVariables.value(this._params[1]);
          var value2;
          if (this._params[2] === 0) {
              value2 = this._params[3];
          } else {
              value2 = $gameVariables.value(this._params[3]);
          }
          switch (this._params[4]) {
              case 0:  // Equal to
                  result = (value1 === value2);
                  break;
              case 1:  // Greater than or Equal to
                  result = (value1 >= value2);
                  break;
              case 2:  // Less than or Equal to
                  result = (value1 <= value2);
                  break;
              case 3:  // Greater than
                  result = (value1 > value2);
                  break;
              case 4:  // Less than
                  result = (value1 < value2);
                  break;
              case 5:  // Not Equal to
                  result = (value1 !== value2);
                  break;
          }
          break;
      case 2:  // Self Switch
          if (this._eventId > 0) {
              var key = [this._mapId, this._eventId, this._params[1]];
              result = ($gameSelfSwitches.value(key) === (this._params[2] === 0));
          }
          break;
      case 3:  // Timer
          if ($gameTimer.isWorking()) {
              if (this._params[2] === 0) {
                  result = ($gameTimer.seconds() >= this._params[1]);
              } else {
                  result = ($gameTimer.seconds() <= this._params[1]);
              }
          }
          break;
      case 4:  // Actor
          var actor = $gameActors.actor(this._params[1]);
          if (actor) {
              var n = this._params[3];
              switch (this._params[2]) {
                  case 0:  // In the Party
                      result = $gameParty.members().contains(actor);
                      break;
                  case 1:  // Name
                      result = (actor.name() === n);
                      break;
                  case 2:  // Class
                      result = actor.isClass($dataClasses[n]);
                      break;
                  case 3:  // Skill
                      result = actor.hasSkill(n);
                      break;
                  case 4:  // Weapon
                      result = actor.hasWeapon($dataWeapons[n]);
                      break;
                  case 5:  // Armor
                      result = actor.hasArmor($dataArmors[n]);
                      break;
                  case 6:  // State
                      result = actor.isStateAffected(n);
                      break;
              }
          }
          break;
      case 5:  // Enemy
          var enemy = $gameTroop.members()[this._params[1]];
          if (enemy) {
              switch (this._params[2]) {
                  case 0:  // Appeared
                      result = enemy.isAlive();
                      break;
                  case 1:  // State
                      result = enemy.isStateAffected(this._params[3]);
                      break;
              }
          }
          break;
      case 6:  // Character
          var character = this.character(this._params[1]);
          if (character) {
              result = (character.direction() === this._params[2]);
          }
          break;
      case 7:  // Gold
          switch (this._params[2]) {
              case 0:  // Greater than or equal to
                  result = ($gameParty.gold() >= this._params[1]);
                  break;
              case 1:  // Less than or equal to
                  result = ($gameParty.gold() <= this._params[1]);
                  break;
              case 2:  // Less than
                  result = ($gameParty.gold() < this._params[1]);
                  break;
          }
          break;
      case 8:  // Item
          result = $gameParty.hasItem($dataItems[this._params[1]]);
          break;
      case 9:  // Weapon
          result = $gameParty.hasItem($dataWeapons[this._params[1]], this._params[2]);
          break;
      case 10:  // Armor
          result = $gameParty.hasItem($dataArmors[this._params[1]], this._params[2]);
          break;
      case 11:  // Button
          result = Input.isPressed(this._params[1]);
          break;
      case 12:  // Script
          result = !!eval(this._params[1]);
          break;
      case 13:  // Vehicle
          result = ($gamePlayer.vehicle() === $gameMap.vehicle(this._params[1]));
          break;
      case 14: // Self Variable
      var value1 = $gameSelfVariables.value([this._mapId,this._eventId,this._params[1]]);
      var value2;
      if (this._params[2] === 0) {
          value2 = this._params[3];
      } else if (this._params[2] === 1){
          value2 = $gameSelfVariables.value([this._mapId,this._eventId,this._params[3]]);
      } else {
          value2 = $gameVariables.value(this._params[3]);
      }
      switch (this._params[4]) {
          case 0:  // Equal to
              result = (value1 === value2);
              break;
          case 1:  // Greater than or Equal to
              result = (value1 >= value2);
              break;
          case 2:  // Less than or Equal to
              result = (value1 <= value2);
              break;
          case 3:  // Greater than
              result = (value1 > value2);
              break;
          case 4:  // Less than
              result = (value1 < value2);
              break;
          case 5:  // Not Equal to
              result = (value1 !== value2);
              break;
      }
          break;
  }
  this._branch[this._indent] = result;
  if (this._branch[this._indent] === false) {
      this.skipBranch();
  }
  return true;
};

// Control Variables
Game_Interpreter.prototype.command122 = function() {
    var value = 0;
    switch (this._params[3]) { // Operand
        case 0: // Constant
            value = this._params[4];
            break;
        case 1: // Variable
            value = $gameVariables.value(this._params[4]);
            break;
        case 2: // Random
            value = this._params[5] - this._params[4] + 1;
            for (var i = this._params[0]; i <= this._params[1]; i++) {
                this.operateVariable(i, this._params[2], this._params[4] + Math.randomInt(value));
            }
            return true;
            break;
        case 3: // Game Data
            value = this.gameDataOperand(this._params[4], this._params[5], this._params[6]);
            break;
        case 4: // Script
            value = eval(this._params[4]);
            break;
        case 5: // Self Variable
            value = $gameSelfVariables.value([this._mapId,this._eventId,this._params[4]])
            break;
    }
    for (var i = this._params[0]; i <= this._params[1]; i++) {
        this.operateVariable(i, this._params[2], value);
    }
    return true;
};

// Control Self Variables
Game_Interpreter.prototype.command357 = function() {
  var value = 0;
  switch (this._params[3]) { // Operand
      case 0: // Constant
          value = this._params[4];
          break;
      case 1: // Variable
          value = $gameVariables.value(this._params[4]);
          break;
      case 2: // Random
          value = this._params[5] - this._params[4] + 1;
          for (var i = this._params[0]; i <= this._params[1]; i++) {
              this.operateSelfVariable(i, this._params[2], this._params[4] + Math.randomInt(value));
          }
          return true;
          break;
      case 3: // Game Data
          value = this.gameDataOperand(this._params[4], this._params[5], this._params[6]);
          break;
      case 4: // Script
          value = eval(this._params[4]);
          break;
      case 5: // Self Variables
          value = $gameSelfVariables.value([this._mapId,this._eventId,this._params[4]]);
          break;
  }
  for (var i = this._params[0]; i <= this._params[1]; i++) {
      this.operateSelfVariable(i, this._params[2], value);
  }
  return true;
};

Game_Interpreter.prototype.operateSelfVariable = function(variableId, operationType, value) {
  var key = [this._mapId, this._eventId, variableId];
  try {
      var oldValue = $gameSelfVariables.value(key);
      switch (operationType) {
      case 0:  // Set
          $gameSelfVariables.setValue(key, oldValue = value);
          break;
      case 1:  // Add
          $gameSelfVariables.setValue(key, oldValue + value);
          break;
      case 2:  // Sub
          $gameSelfVariables.setValue(key, oldValue - value);
          break;
      case 3:  // Mul
          $gameSelfVariables.setValue(key, oldValue * value);
          break;
      case 4:  // Div
          $gameSelfVariables.setValue(key, oldValue / value);
          break;
      case 5:  // Mod
          $gameSelfVariables.setValue(key, oldValue % value);
          break;
      }
  } catch (e) {
      $gameSelfVariables.setValue(key, 0);
  }
};

Game_Interpreter.prototype.selfVariableValue = function(variableId) {
  var key = [this._mapId,this._eventId,variableId];
  return $gameSelfVariables.value(key);
};

//-----------------------------------------------------------------------------
// Game_BattlerBase
//
// The superclass of Game_Battler. It mainly contains parameters calculation.

Game_BattlerBase.prototype.paramMax = function(paramId) {
    if (paramId === 0) {
        return 999999;  // MHP
    } else if (paramId === 1) {
        return 999999;    // MMP
    } else {
        return 99999;
    }
};

//-----------------------------------------------------------------------------
// Window_Base
//
// The superclass of all windows within the game.

Window_Base.prototype.convertEscapeCharacters = function(text) {
    text = text.replace(/\\/g, '\x1b');
    text = text.replace(/\x1b\x1b/g, '\\');
    text = text.replace(/\x1bV\[(\d+)\]/gi, function() {
        return $gameVariables.value(parseInt(arguments[1]));
    }.bind(this));
    text = text.replace(/\x1bSV\[(\d+)\]/gi, function() {
        return $gameMap.selfVariableValue(parseInt(arguments[1]));
    }.bind(this));
    text = text.replace(/\x1bN\[(\d+)\]/gi, function() {
        return this.actorName(parseInt(arguments[1]));
    }.bind(this));
    text = text.replace(/\x1bP\[(\d+)\]/gi, function() {
        return this.partyMemberName(parseInt(arguments[1]));
    }.bind(this));
    text = text.replace(/\x1bG/gi, TextManager.currencyUnit);
    return text;
};

// region Extra Functions

// Additional Troop Page Conditions
Game_Troop.prototype.meetsConditions = function(page) {
    var c = page.conditions;
    if (!c.turnEnding && !c.turnValid && !c.enemyValid && !c.actorValid && !c.switchValid && !c.variableValid && !c.stateValid && !c.partyValid && !c.scriptValid) {
        return false;  // Conditions not set
    }
    if (c.turnEnding) {
        if (!BattleManager.isTurnEnd()) {
            return false;
        }
    }
    if (c.turnValid) {
        var n = this._turnCount;
        var a = c.turnA;
        var b = c.turnB;
        if ((b === 0 && n !== a)) {
            return false;
        }
        if ((b > 0 && (n < 1 || n < a || n % b !== a % b))) {
            return false;
        }
    }
    if (c.enemyValid) {
        var enemy = $gameTroop.members()[c.enemyIndex];
        if (!enemy || enemy.hpRate() * 100 > c.enemyHp) {
            return false;
        }
    }
    if (c.actorValid) {
        var actor = $gameActors.actor(c.actorId);
        if (!actor || actor.hpRate() * 100 > c.actorHp) {
            return false;
        }
    }
    if (c.switchValid) {
        if (!$gameSwitches.value(c.switchId)) {
            return false;
        }
    }
    if (c.variableValid) {
        var key = c.variableId ? c.variableId : 0;
        if (!c.variableValue) {c.variableValue = 0;};
        switch (c.variableOperator) {
            case 0: // Greater then or Equal to
                if ($gameVariables.value(key) < c.variableValue) {
                    return false;
                }
                break;
            case 1: // Greater than
                if ($gameVariables.value(key) <= c.variableValue) {
                    return false;
                }
                break;
            case 2: // Equal to
                if ($gameVariables.value(key) != c.variableValue) {
                    return false;
                }
                break;
            case 3: // Less than
                if ($gameVariables.value(key) >= c.variableValue) {
                    return false;
                }
                break;
            case 4: // Less than or Equal to
                if ($gameVariables.value(key) > c.variableValue) {
                    return false;
                }
                break;
            case 5: // Not Equals to
                if ($gameVariables.value(key) === c.variableValue) {
                    return false;
                }
                break;
            default: // Default to Greater than or Equal to
                if ($gameVariables.value(key) < c.variableValue) {
                    return false;
                }
                break;
        }
    }
    if (c.stateValid) {
        if (!c.stateActorId) {c.stateActorId = 1;};
        if (!c.stateValue) {c.stateValue = 1;};
        
        if (!c.stateCharacter) {
            if (!$gameActors.actor(c.stateActorId).isStateAffected(c.stateValue)) {
                return false;
            }
        }
        else {
            if (!$gameTroop.members()[c.stateEnemyIndex].isStateAffected(c.stateValue)) {
                return false;
            }
        }
    }
    if (c.partyValid) {
        if (!c.partyId) {c.partyId = 1;};

        switch (c.partyType) {
            case 0:
                if (!$gameParty.hasItem($dataItems[c.partyId])) {
                    return false
                }
                break;
            case 1:
                if (!$gameParty.hasItem($dataWeapons[c.partyId])) {
                    return false
                }
                break;
            case 2:
                if (!$gameParty.hasItem($dataArmors[c.partyId])) {
                    return false;
                }
                break;
        }
    }
    if (c.scriptValid) {
        try {
            var run = false;
            var script = eval(c.script);
            if (!run) {
                return false
            }
        }
        catch (e) {
            SceneManager.onError(e);
            return false;
        }
    }
    return true;
}

// Switch Statement
Game_Interpreter.prototype.command358 = function() {
    var result;
    switch (this._params[1]) {
        case 0: // Variable
            result = $gameVariables.value(this._params[2]);
            break;
        case 1: // Self Variable
            result = $gameSelfVariables.value([this._mapId, this._eventId, this._params[2]]);
            break;
        case 2: // Inventory
            switch (this._params[2]) {
                case 0: // Items
                    result = $gameParty.numItems($dataItems[this._params[3]]);
                    break;
                case 1: // Weapons
                    result = $gameParty.numItems($dataWeapons[this._params[3]]);
                    break;
                case 2: // Armors
                    result = $gameParty.numItems($dataArmors[this._params[3]]);
                    break;
            }
            break;
        case 3: // Character Direction
            var character = this.character(this._params[2]);
            if (character) {
                result = character.direction();
            }
            break;
        case 4: // Script
            result = eval(this._params[2])
            break;
    }
    var found;
    for (var i = 0; i < this._params[0].length; i++) {
        if (result == this._params[0][i]) {
            this._branch[this._indent] = i;
            found = true;
            break;
        }
    }
    if (!found) {
        var defaultcase = this._params[this._params.length - 1]
        if (defaultcase[0] === "Default" && defaultcase[1] === true) {
            this._branch[this._indent] = this._params[0].length;
        }
    }
    
    return true;
}

// Case
Game_Interpreter.prototype.command658 = function() {
    if (this._branch[this._indent] !== this._params[0]) {
        this.skipBranch();
    }
    return true;
}

// Sound Manager
Game_Interpreter.prototype.command1002 = function() {
    switch (this._params[0]) {
        // Bgm
        case 0:
            switch (this._params[1]) {
                // Stop Sound
                case 0:
                    AudioManager.stopBgm();
                    break;
                // Save Sound
                case 1:
                    $gameSystem[`_savedBgm${this._params[2]}`];
                    break;
                // Replay Sound
                case 2:
                    if ($gameSystem[`_savedBgm${this._params[2]}`]) {
                        AudioManager.replayBgm($gameSystem[`_savedBgm${this._params[2]}`])
                    }
                    break;
                // Fade Out Bgm
                case 3:
                    AudioManager.fadeOutBgm(this._params[2]);
                    break;
                // Play Bgm
                case 4:
                    AudioManager.playBgm(this._params[2]);
                    // Fade In Bgm
                    if (this._params[3]) {
                        AudioManager.fadeInBgm(this._params[3]);
                    }
                    break;
            }
            break;
        // Bgs
        case 1:
            switch (this._params[1]) {
                // Stop Sound
                case 0:
                    AudioManager.stopBgs();
                    break;
                // Save Sound
                case 1:
                    $gameSystem[`_savedBgs${this._params[2]}`];
                    break;
                // Replay Sound
                case 2:
                    if ($gameSystem[`_savedBgs${this._params[2]}`]) {
                        AudioManager.replayBgs($gameSystem[`_savedBgs${this._params[2]}`])
                    }
                    break;
                // Fade Out Bgs
                case 3:
                    AudioManager.fadeOutBgs(this._params[2]);
                    break;
                // Play Bgs
                case 4:
                    AudioManager.playBgs(this._params[2]);
                    // Fade In Bgm
                    if (this._params[3]) {
                        AudioManager.fadeInBgs(this._params[3]);
                    }
                    break;
            }
            break;
        // Me
        case 2:
            switch (this._params[1]) {
                // Stop Sound
                case 0:
                    AudioManager.stopMe();
                    break;
                // Play Me
                case 1:
                    AudioManager.playMe(this._params[2]);
                    break;
            }
            break;
        // Se
        case 3:
            switch (this._params[1]) {
                // Stop Sound
                case 0:
                    AudioManager.stopSe();
                    break;
                case 1:
                    AudioManager.playSe(this._params[2]);
                    break;
            }
            break;
    }

    return true;
}
} // window.OneMakerMVCoreLoaded End