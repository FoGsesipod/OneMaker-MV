# Changelog
## Version 1.0.3  
Added Variable Operator selection for Event Page Conditions.  
Added Script Command to Event Page Conditions **(NOTE: You should really only use this if you know what you are doing!)**  
Added identification to Control Self Variable commands in Event Lists. (Self Variables are still unaccessible). 
Added the ability to change the Event Command Select menu into one giant tab instead of 3, disbaled by default. Check `Constants.qml`.  

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
