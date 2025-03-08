# OneMaker-MV
Injects UI modifications to RPGMaker MV, designed for modding OMORI.  
HUGE Thanks to Rph and Draught!  

## To Install:
Place the contents of OneMaker MV into the steam/steamapps/common/RPGMaker MV/ folder.   

To get maps to display without using parallaxes, use [The Omori Map Renderer](https://github.com/rphsoftware/omori-map-preview-renderer/actions/runs/13727034987/artifacts/2712892480).  
Parallaxes still work and will always be displayed under the tiled map images.  
To manually add maps use Export As Image in tiled, select a `scaled` folder in your playtest.  
The naming scheme follows tileds, which should be `mapXXX.png` (XXX being a number).  
![Scaled](https://github.com/user-attachments/assets/731ac594-87df-4c00-a506-e5daa35798b0).  

## To get the RPGMaker MV resources
Requirements: [Rust](https://www.rust-lang.org/tools/install).  
Download and build [QT Extract](https://github.com/axstin/qtextract).  
Drag and Drop RPGMV.exe onto qtextract.exe and follow the on screen instructions.  

## To Build QT5Core.dll Yourself
Requires visual stuido 2013, which you can get from [Archive.org](https://archive.org/details/en_visual_studio_community_2013_with_update_5_x86_dvd_6816332).  
Download [QT 5.4.2](https://download.qt.io/new_archive/qt/5.4/5.4.2/single/qt-everywhere-opensource-src-5.4.2.zip) and follow [these instructions](https://doc.qt.io/archives/qt-5.5/windows-building.html).  
Then replace `qresource.cpp` from this repositroy into the QT 5.4.2 archive.  

## Screenshots
![Sample0](https://github.com/user-attachments/assets/7c7dba64-c0d4-4d68-a542-06da93b634b8)
![Sample1](https://github.com/user-attachments/assets/7ba5a5e9-7627-4bec-9dbe-29b17d81e213)
![Sample2](https://github.com/user-attachments/assets/3192ebaa-ef99-405a-b048-19d20714387f)
![Sample3](https://github.com/user-attachments/assets/981eda08-e2ea-4b02-9ffd-aeeb1f88c80f)
![Sample4](https://github.com/user-attachments/assets/9db921e9-ba18-47b8-8620-fce1f37f6f7a)
![Sample5](https://github.com/user-attachments/assets/0b880a3c-31f4-48ec-ae0d-3a9a8f536725)
![Sample6](https://github.com/user-attachments/assets/10bcce6e-6457-451d-8435-cf608169eee2)
