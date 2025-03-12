# OneMaker-MV
Injects UI modifications to RPGMaker MV, designed for modding OMORI.  
However, you can use this in other RPGMaker MV Projects, set `expectedContext` to `false` in `_hijack_root/qml/Singletons/One_WorkingMode.qml`.  
HUGE Thanks to Rph and Draught!  
Linux compatibility thanks to SoundOfSpouting!

## Features:
Resizable window sizes, such as the Database and Event Viewer.  
Event Page Conditions now have variable operator selection, Self Variables, and Self Switches E-Z are available.  
Conditional Branches can now use check Self Variables, you also get access to Control Self Variable event commands.  
Map image files in the `render` folder will now automatically be displayed onto maps, using a stretch format so they don't have to be resized to match MV's 48x48 tile sizes.  
Event Block Selection screen can be made into one giant tab instead of having three tabs.  
The Show Text command is now formatted correctly to fit OMORI's face images.
Comments and Script Commands can now have way more lines.  
And other smaller improvements.  

## To Install:
Place the contents of OneMaker-MV.7z into the `steam/steamapps/common/RPGMaker MV/` folder.  
There is user configurable settings located in the `One_X.qml` files (Where X is related to what the file is for). These files are located in `_hijack_root/qml/Singletons/`.  

## Tiled Map Display:
To get maps to display without using parallaxes, use [The Omori Map Renderer](https://github.com/rphsoftware/omori-map-preview-renderer/actions/runs/13727034987) (You want the file with `.exe` in its name, but it is an archive).  
Parallaxes still work and will always be displayed under the Tiled map images.  
To manually add maps use Export As Image in Tiled, select a `render` folder in your playtest.  
The naming scheme follows Tileds, which should be `mapX.png` (X being a number).  
![Tiled Map Folder](https://github.com/user-attachments/assets/137a8bc5-d6a3-40a2-bccd-157a0337a687).  

## To get the RPGMaker MV resources
Requirements: [Rust](https://www.rust-lang.org/tools/install).  
Clone [QT Extract](https://github.com/axstin/qtextract).  
Extract it to some folder, then open powershell and navigate to the folder.  
Afterwords enter:
```
Cargo build
```
To build QT Extract, the `qtextract.exe` will be located in `target/debug/`
Drag and Drop `RPGMV.exe` located in `steam/steamapps/common/RPGMaker MV/` onto `qtextract.exe` and dump whatever resource you would like.  
Nearly all of the relevant QML files are in the first resource, so you can dump it by entering `1` on the command prompt that QT Extract opens.  

Once the application has finished running, the extracted resources will be in `steam/steamapps/common/RPGMaker MV/qtextract-output`.  

Note: QT Extract places its files one level lower then they actually should be.  
So the ressources from the first resource bundle will output to `qml/qml/` when the actual resource path is only `qml/`.  

## To Build QT5Core.dll Yourself
Requirements: [Visual Stuido 2013](https://archive.org/details/en_visual_studio_community_2013_with_update_5_x86_dvd_6816332).  
Clone [QT 5.4.2](https://download.qt.io/new_archive/qt/5.4/5.4.2/single/qt-everywhere-opensource-src-5.4.2.zip).  
First extract QT 5.4.2 to `C:/QT/qt-5/`.  
Create a new file named `QT_Environment.cmd` and stick the following text into it:  
```
CALL "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
SET _ROOT=C:\qt\qt-5
SET PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
SET QMAKESPEC=win32-msvc2013
SET _ROOT=
cmd /k
```
Now we need to open a QT Environment cmd, we do this by:  
Open or navigate a command prompt to C:/QT/  
Run this command in the command prompt:  
```
%SystemRoot%\system32\cmd.exe /E:ON /V:ON /k c:\qt\QT_Environment.cmd
```
Followed with:
```
cd qt-5
```
Finally run:
```
configure -release -nomake examples -nomake qtwebkit -nomake qtwebengine -opensource
```
And accept the license (`Y`).  
Then replace `qresource.cpp` from this repositroy into `C:\QT\QT-5\qtbase\src\corelib\io\`.  

Then you can run `nmake` when inside a QT Environment cmd to compile QT, for this project we only need to compile `QT5Core.dll`, which shouldn't take too much time.  
The `QT5Core.dll` should appear in `C:/QT/qt-5/qtbase/bin/`.  
(These instructions are based off of the instructions [here](https://doc.qt.io/archives/qt-5.5/windows-building.html)).  

## Screenshots
![Sample0](https://github.com/user-attachments/assets/7c7dba64-c0d4-4d68-a542-06da93b634b8)
![Sample1](https://github.com/user-attachments/assets/7ba5a5e9-7627-4bec-9dbe-29b17d81e213)
![Sample2](https://github.com/user-attachments/assets/3192ebaa-ef99-405a-b048-19d20714387f)
![Sample3](https://github.com/user-attachments/assets/981eda08-e2ea-4b02-9ffd-aeeb1f88c80f)
![Sample4](https://github.com/user-attachments/assets/9db921e9-ba18-47b8-8620-fce1f37f6f7a)
![Sample5](https://github.com/user-attachments/assets/0b880a3c-31f4-48ec-ae0d-3a9a8f536725)
![Sample6](https://github.com/user-attachments/assets/10bcce6e-6457-451d-8435-cf608169eee2)
