# OneMaker-MV
Injects UI modifications to RPGMaker MV, designed for modding OMORI.
HUGE Thanks to Rph and Draught!

## Screenshots
![Sample0](https://github.com/user-attachments/assets/7c7dba64-c0d4-4d68-a542-06da93b634b8)
![Sample1](https://github.com/user-attachments/assets/7ba5a5e9-7627-4bec-9dbe-29b17d81e213)
![Sample2](https://github.com/user-attachments/assets/3192ebaa-ef99-405a-b048-19d20714387f)
![Sample3](https://github.com/user-attachments/assets/981eda08-e2ea-4b02-9ffd-aeeb1f88c80f)
![Sample4](https://github.com/user-attachments/assets/9db921e9-ba18-47b8-8620-fce1f37f6f7a)
![Sample5](https://github.com/user-attachments/assets/0b880a3c-31f4-48ec-ae0d-3a9a8f536725)
![Sample6](https://github.com/user-attachments/assets/10bcce6e-6457-451d-8435-cf608169eee2)

## To Install:
Place the contents of OneMaker MV into the steam/RPG Maker MV folder.  
NOTE: Parallaxes are disabled **in the editor** (they will still work in game).  
To get maps to display use [The Omori Map Renderer](https://github.com/rphsoftware/omori-map-preview-renderer/releases/tag/0.1.0).  
(Maps that use tiled 1.0.4+ wont render using that tool *yet*).  

To manually add maps use Export As Image in tiled, select a `scaled` folder in your playtest.  
The naming scheme follows tileds, which should be `mapXXX.png` (XXX being a number).  
![Scaled](https://github.com/user-attachments/assets/731ac594-87df-4c00-a506-e5daa35798b0)

## To Build QT5Core.dll Yourself
Take `qresource.cpp` and replace it in [This Repository](https://github.com/rochus-keller/Qt-5.4.2), then build that as normal.
