# <u>WORK IN PROGRESS</u>

# Explosive.ws to Godot Workflow

Scripts and skeleton resources to support the *mostly automated* explosive.ws to blender to godot workflow. You can buy or download them from the Explosive link below.

<p align="left">
  <a href="https://www.explosive.ws/products/rpg-animation-fbx-for-godot-blender">
    <img src="logos/ExplosiveLLC.svg" height="100" width="100" alt="Explosive.WS"></a>
  <img src="logos/next-arrows-svgrepo-com.svg" height="25" width="100">
  <a href="https://blender.org">
    <img src="logos/blender.svg" width="100" alt="Godot Engine logo"></a>
  <img src="logos/next-arrows-svgrepo-com.svg" height="25" width="100">
  <a href="https://godotengine.org">
    <img src="logos/logo_outlined.svg" width="200" alt="Godot Engine logo"></a>

</p>




You can also see a video walk-through of the process here: (**insert youtube link here**)

# Explosive Animations

###### Explosive animations currently supplies 1116 high quality RPG locomotion and combat animations *mostly ready* for Godot.

The animations are supplied in a single zip file with animations organized into folders by equipped weapon (weapons are not included, these are just animations and rigging). The animations are not 100% ready to be used in godot, but following this easy workflow will make the animations ready to for animating player and non-player characters alike.

Download the zip file and extract the contents into a working folder.

Animations are organized into folders named for the group of animations associated with the intended equipped weapon. Each animation is its own individual FBX file. You can leave them organized as is, or if you prefer to organize them differently is entirely up to you. Unless you have a specific need, it generally makes sense to just leave them as is. It will make working with them in the Godot Animation Player a little more organized and less of a headache.



# Blender

###### We are going to use blender to convert the FBX files into GLB files, which the Godot engine more readily recognizes and the engine processes the files faster.

The python script has been tested with blender 3.6 thru 4.2.

1. Start Blender

2. Open the Scripting Tab and click on New

3. Copy and paste the contents of the explosive_anim_importer.py into the scripting editor in Blender

4. Change the **folder_name** variable to the location of the folder holding the animations you wish to create your library from. *Note: If you are using Windows, please be sure to include the drive letter (ex. folder_path = "C:\users\yourname\animations\unarmed" )*

5. If you plan to use root motion, then change **remove_root_motion** variable to **False**. This option will strip the root motion tracks completely out of the animation, and you will have to repeat the process if you change your mind. *NOTE: If you are adding animations to your player through composition, root motion should probably be disabled*

6. Press the Run Script Arrow button immediately above the script, wait a few moments until you see the Armature object in the inspector.

7. Open the Animation tab and switch the bottom frame from Dope Sheet to Action Editor and verify that each animation processed correctly.

8. Export the library by going to the File Menu > Export > gLTF

9. Name the file as you wish (perhaps the same as the source folder name).

# Godot Engine



## 
