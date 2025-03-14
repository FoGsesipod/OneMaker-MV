# Changelog
## Version 1.0.6
Fixed Self Variable Event Page Conditions from not actually working if you just enabled them then set a value.  
Expanded the loggers code.  

### Changed Files
Modified:
- qml\\_OneMakerMV\One_CustomLogger.qml
- qml\Event\Group_EventConditions.qml

## Version 1.0.5
Added the ability to disable OMORI specific changes so OneMaker-MV can be used for other projects, without losing or breaking features.  
Added Self Variable operand for Control Variables and Control Self Variables.  
Upgraded Self Variable display in event to this format: `#X Name` where `X` is the id and `Name` is the name defined in `One_SelfVariableNamingScheme.qml`.  
- This is for preperation sake mostly, if figuring out how to assign per-event Self Variable names is ever made apparent. 

Added a method to get console.log data for help with development. This `Console.log` file will appear next to `RPGMV.exe`.  

### Changed Files
Added:
- qml\Event\Group_Operand.qml
- qml\Singletons\One_WorkingMode.qml
- qml\Main\MainWindow.qml
- qml\\_OneMakerMV\One_CustomLogger.qml
- qml\\_OneMakerMV\qmldir

Modified:
- qml\Controls\FaceImageBox.qml
- qml\Database\Edit_Enemies.qml
- qml\Event\EventCommandTexts.qml
- qml\Event\Group_SelfVariableRange.qml
- qml\Singletons\One_WindowSizes.qml Note: This file only changed the `Default` constants, the `Upgrading from 1.0.4` zip does not include these changes.
- qml\Singletons\qmldir
- hijack.rcc

## Version 1.0.4
Fixed an oversight with operators in if conditions (Thanks SoundofSpouting).  
Injector improved to inject a new resource file, which will contain dummy files for the hijacker to replace (💕 Rph).  
Added better detection for event self variable commands (It now displays their parameters).  
Also added parameters for Conditional Branch Self Variables.  
Added Self Variables to Event Page Conditions.  
Added Self Variable conditions to Conditional Branches.  
Finally, Added Control Self Variables to the Event Command List!  
- `qml\Singleton\One_SelfVariableNaming.qml` has a modifiable array for its naming scheme, either using numbers (EX: 0, 1, 2, 3...) or words (EX: "Zero", "One", "Two", "Three"...).  
- You can also increase/decrease the amount of self variables per event available to you in that array.  

All `Constants` from `Constants.qml` have been moved to separate files in `qml\Singleton\One_X.qml` (Where X is related to what the file does) to make updating user friendly, so your configurable settings aren't overwritten every update.  

### Changed Files:
Added:  
- qml\Event\EventCommands\EventCommand111.qml  
- qml\Event\EventCommands\EventCommand357.qml  
- qml\Event\EventCommandTexts.qml  
- qml\Event\Group_SelfVariableRange.qml
- qml\Event\Tab_ConditionalBranch1.qml  
- qml\Singleton\One_EventCommandSelectPage.qml
- qml\Singleton\One_SelectAllOnFocus.qml
- qml\Singleton\One_SelfVariableNamingScheme.qml
- qml\Singleton\One_WindowSizes.qml
- qml\Singleton\qmldir

Changed:  
Every single file was changed.  

### NOTE:
Because every single file was changed, I recommend **deleting** the `_hijack_root` folder in your RPGMaker MV directory (Make sure to backup any custom window sizes you have in `Constants.qml`!!!).  
Moving Forward, I will try to add a "Updaing from Previous Update" package each release after this one, which will only include the added/changed files from the previous release.  

## Version 1.0.3  
Added Variable Operator selection for Event Page Conditions.  
Added Script Command to Event Page Conditions **(NOTE: You should really only use this if you know what you are doing!)**  
Added identification to Control Self Variable commands in Event Lists. (Self Variables are still unaccessible). 
Added the ability to change the Event Command Select menu into one giant tab instead of 3, disabled by default. Check `Constants.qml`.  

Changed Tiled Map rendering to use stretch, lower res map image files will now fill the map correctly (No more needing 150% Tiled Images!).  
- Following this change, instead of using the `scaled` folder in root directory, we now use `render` (This is OMORI Map Renderer's default 100% scaling maps).  
- Note: if the map in rpgmaker isn't sized exactly the same as Tiled then the images wont line up.

Splash updated a little bit more - thanks again pigmask.  

### Changed Files:  
Added:  
- qml\Event\Dialog_EventCommandSelect.qml
- qml\Event\Group_EventConditions.qml  
- qml\Singletons\EventCommands.qml  

Changed:
- qml\Map\MapEditorBaseView.qml
- qml\Singletons\Constants.qml
  - (Lines will only match up if you go from top to bottom).
  - Lines 230-244
  - Lines 371-375

## Version 1.0.2A  
Fixed animations tab in database not being sized properly.  
Changed "Show in editor" to say "Show Tiled maps" with a matching tooltip to reflect OneMaker MV's changes.  
Updated the 720p preset to actually be useable on 720p resolutions.  
Added a directory list file (Won't appear in releases zip).  

## Version 1.0.2
Added easy to modify window sizes, in `Constants.qml`.  
Added bool for selecting all characters in Database note boxes, in `Constants.qml`. Default is false.  
Added back parallaxes, which are always enabled by default now, but are displayed below images in the `scaled` folder (This allows viewing of maps almost exactly as they will appear in-game, also allows viewing maps that only have parallaxes).  
Changed the "Show in editor" tickbox under parallax selection in map properties to instead enable/disable `scaled` folder images. This can help with crash prevention if a maps image file is extremely large.  
Added a custom `Splash.png`, Thank you pigmask for the base.  

## Version 1.0.1
Added comments in all files to indicate where and what was changed.  
Made better use of white space in Items, Weapons, Armors, and Enemies.  
Made better use of white space for Group_Damage, Group_Effects, and Group_AnimationTimings.  

## Version 1.0.0  
Increased tons of windows sizes.  
Increased script and comment block limits.  
10k Database limits.  
Self Switch E-Z accessible.  
Wait duration max increased to 99999.  
Maps automatically grab tiled images from `scaled` folder in root, ignoring the selected parallaxes.  
Event Page maxes increased to 30.  
Fixed the sizing of portraits in RPG Makers Show Text command.  
