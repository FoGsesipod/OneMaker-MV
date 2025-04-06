# Changelog
## Versions 1.2
Changes to Working Mode and window sizing, allowing individual toggles and a global disable to UI sizing to fix users who have screen resolutions lower then 900p.  
Added Switch Statement Event Command, Additional Troop Conditions, and converted the Sound Manager to use real Event Commands.  
Added a `OneMakerMV-Core.js` Plugin, which is now required for using certain features that would not work otherwise in-game.  
- This plugin **must** be placed at the very very top, in the **first** slot of the plugin manager *and* be enabled, to enable these additional features.  

Expanded Event Test to obtain the event's id, and allow selection of where the player should appear on the map.  
- This requires the `Geo_ImprovedEventTest.js` Plugin, which is available in the `Plugins.7z` file in OneMaker MV's release.  

Added the ability to reset your OneMaker MV's settings with a new menu.  
Massively upgraded the Event Searcher for more intricate searching.  
Improved the Installer for better handling of Image Packs, it will also notify you if a new version of OneMakerMV-Core is available in the future.  

### Note:
Due to changes in 1.2, you will probably need to modify the `Group Note Database Width` setting in the `Window Sizes Menu`, alternativily, reset your settings.

## Version 1.1.2
Added Linux support with thanks to Rph and SoundOfScooting!  
Changed F1 hotkey to open the plugin help menu, almost everywhere.  
Added a settings option to change the default blend mode when creating new cells in the Animations Database tab.  
Added automation for creating movement graphics for actors.  
Fixed default Show Text preview not working at all.  
Added the ability to find enemies on the Enemy List in the Troops Database tab.  
Added the self switch array to Array Naming settings menu (Please read the tooltip before you go and change it).  

## Version 1.1.1
Fixed condition branch variable not working.  
Audited all files to make sure changes were necessary, removed some files where their changes were added elsewhere, added comments to undocumented changes.  
Updated Installer to bypass execution policy, detect if the user has replaced the global fonts, and added version checking for all future releases.  
- You now need to run `Run Installer.bat` instead of `OneMaker MV Installer.ps1`

## Version 1.1.0
Improve the Yaml Message Preview.  
Added a sound manager for better control over audio.  
Added a player transfer script creator, that includes a map viewer.  
added a toggleable map to movement route commands, with selected tile information.  
Settings can now be changed in-engine, no more browsing files in `_hijack_root`.  
Revamped how settings are saved, so that they are created and stored in a json file outside of OneMaker MV's `_hijack_root`, the location is `Documents/OneMakerMV/`.  
 - This means that settings have unfortunately, been reset again. But should absolutely never need to be reset again.

## Added an installer!
The installer is a powershell script file, which requires windows to allow unsigned local scripts to run.  
You can enable this setting by:  

### Windows 11:
Open Settings, go to `System`, click the `For Developers` tab, open the `PowerShell` dropdown and enable: `Change execution policy to allow local PowerShell scripts to run without signing. Require signing for remote scripts.`  

![Execution Policy Windows 11](https://github.com/user-attachments/assets/97a32c99-ffa3-4477-8e87-23adf5ed5853)

### Windows 10:
Open Settings, go to `Update & Security`, click the `For Developers` page, check `Change execution policy to allow local PowerShell scripts to run without signing. Require signing for remote scripts.`  

![Execution Policy Windows 10](https://github.com/user-attachments/assets/0a9faa21-f9f1-44e1-bb96-c18bc8e4ae2c)

### Changed FIles
- Almost Every Single File Was Changed

## Version 1.0.8
Added a Yaml Message Selector, to automate and or maybe make adding ShowMessage/AddChoice/ShowChoices plugin commands faster.  
Added the Krypt Image Pack.  
Modified audio pitch to go as low as 10% and as high as 200%.  
Increased the maximun trait parameter to 10k.  

### Changed Files
Added:
- qml\Controls\YamlFileListBox.qml
- qml\Dialogs\Dialog_YamlSelector.qml
- qml\Event\EventCommandBase.qml
- qml\Event\Event\Dialog_EventCommandSelect.qml
- qml\Event\EventCommands\EventCommand1356.qml
- qml\ObjControls\ObjYamlEllipsisBox.qml
- qml\Singletons\One_YamlIdentifiers.qml
- qml\Images\Krypt\\*
- qml\Layouts\Layout_AudioSelector.qml
- qml\Layouts\Layout_TraitEdit.qml

Modified:
- qml\Event\Dialog_EventCommandSelect.qml
- qml\Singletons\EventCommands.qml
- qml\Singletons\qmldir
- qml\\_OneMakerMV\One_ImagePack.qml
- qml\Event\EventCommandBase.qml
- hijack.rcc

## Version 1.0.7
Made ShowText preview use the OMORI_GAME2 font.  
Allowed modification of the maximun level of Actors and Classes database tab, and the Change Level Event Command (See One_MaxLevel.qml).  
Added infrastucture for changing the icons/images the editor uses (See One_UserImageSelection.qml).  
Currently available icon packes:  
- Default
- MZ
- Koffin's Pack

### Changed Files
Added:  
- qml\BasicControls\FontManager.js  
- qml\BasicControls\Palette.qml  
- qml\BasicControls\MessageBox.qml  
- qml\BasicControls\MessageBoxWithUrl.qml  
- qml\BasicControls\ToolButton.qml  
- qml\Controls\FileListBox.qml  
- qml\Dialogs\Dialog_ParameterCurves.qml
- qml\Events\EventCommands\EventCommand316.qml  
- qml\Events\EventCommands\EventCommand357.qml
- qml\Images\\**
- qml\Event\Canvas_TextPreview.qml
- qml\Fonts\OMORI_GAME2.tff
- qml\Main\MainMenu.qml
- qml\Map\MapSelectTreeBox.qml
- qml\Singletons\One_UserImageSelection.qml
- qml\Singletons\One_MaxLevel.qml 
- qml\\_OneMakeMV\One_ImagePack.qml

Modified:
- qml\Singletons\One_WorkingMode.qml // This file will not be included in the Upgrade Package.  
- qml\Database\Edit_Actors.qml  
- qml\Singletons\qmldir
- qm\\_OneMakerMV\qmldir

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
