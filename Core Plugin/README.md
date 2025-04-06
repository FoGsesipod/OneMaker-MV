# OneMaker MV Core Plugin
This plugin is essential for making certain functionality of OneMaker MV work when you deploy or playtest your project.  
You must absolutely place this plugin at the very top of the plugin manager, as it is basically a modification to the core `rpg_*.js` files.   

### The current list modifications this plugin has:  
- Ports Self Variables for use outside of OMORI.
- Ports Script Event Page Condition for use outside of OMORI.
- Adds additional conditions to Troops.
- Modifies Control Variables to be able to set their value to that of a Self Variable.
- Adds Switch Statements.
- Adds a Sound Manager.

### The latest version of this file is: `Version 1.0.0`. 

# Geo Improved Event Test Plugin
This plugin is to improve the Event Test feature of RPG Maker MV.  
It obtains the event Id that running for "this event" checks, as well as allows you to select where the player should spawn in the map.  