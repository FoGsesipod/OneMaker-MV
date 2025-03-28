//===============================================================================================================
// FoGsesipod - OneMaker MV Core
// OneMakerMV-Core.js
//===============================================================================================================

//===============================================================================================================
/*:
 * @plugindesc Core functionality for OneMakerMV
 * @author FoGsesipod | Sound
 * @help
 * ===============================================================================================================
 * Adds core changes necessary for features the OneMaker MV adds.
 * ===============================================================================================================
 * 
 * List of current additional feature:
 * - SelfVariable class necessary for using Self Variables.
 * - Modifies event page meetConditions to allow Script Page Condition.
 * - Increases the maximun parameters for enemies.
 * 
 * ===============================================================================================================
 * Version History:
 * ===============================================================================================================
 * 
 * 1.0.0 - Initial Release.
*/
//===============================================================================================================

// region Core Functions

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
  return this._interpreter.selfVariableValue(variableId) || "";
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
          case 1: // Greather than
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
      var key = [this._mapId, this._eventId, c.selfVariableId];
      switch (c.selfVariableOperator) {
          case 0: // Greater than or Equal to
              if ($gameSelfVariables.value(key) < c.selfVariableValue) {
                  return false;
              }
              break;
          case 1: // Greather than
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
      case 5:
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