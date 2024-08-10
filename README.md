# Explosive.ws to Godot Workflow

Scripts and skeleton resources to create a ***mostly automated*** explosive.ws to blender to godot workflow. You can buy or download the animations from the Explosive link below.

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

##### Explosive animations currently supplies 1116 high quality RPG locomotion and combat animations *mostly ready* for Godot.

The animations are supplied in a single zip file with animations organized into folders by equipped weapon (weapons are not included, these are just animations and rigging). The animations are not 100% ready to be used in godot, but following this easy workflow will make the animations ready to for animating player and non-player characters alike.

Download the zip file and extract the contents into a working folder.

Animations are organized into folders named for the group of animations associated with the intended equipped weapon. Each animation is its own individual FBX file. You can leave them organized as is, or if you prefer to organize them differently is entirely up to you. Unless you have a specific need, it generally makes sense to just leave them as is. It will make working with them in the Godot Animation Player a little more organized and less of a headache.

# Blender

##### We are going to use blender to convert the FBX files into GLB files, which the Godot engine more readily recognizes and the engine processes the files faster.

The python script has been tested with blender 3.6 thru 4.2.

1. Start Blender

2. Open the Scripting Tab and click on New

3. Copy and paste the contents of the explosive_anim_importer.py into the scripting editor in Blender

4. Change the **folder_name** variable to the location of the folder holding the animations you wish to create your library from. *Note: If you are using Windows, please be sure to include the drive letter (ex. folder_path = "C:\users\yourname\animations\unarmed" )*

5. If you plan to use root motion, then change **remove_root_motion** variable to **False**. This option will strip the root motion tracks completely out of the animation, and you will have to repeat the process if you change your mind. *NOTE: If you are adding animations to your player through composition, root motion should probably be disabled*

6. Press the Run Script Arrow button immediately above the script, wait a few moments until you see the Armature object in the inspector.

7. Open the Animation tab and switch the bottom frame from Dope Sheet to Action Editor and verify that each animation processed correctly.

8. Export the library by going to the File Menu > Export > gLTF

9. Name the file as you wish (perhaps the same as the source folder name), and export the file with the default settings.

# Godot Engine

##### To make the animations Godot ready, we need to modify the key frames of the Hips bone. This will prevent the player from *floating* above the floor by the animations.

*You must have a rigged and working character model to animate. You can try using the X-bot or Y-bot from [Mixamo](https://www.mixamo.com) or purchase some great looking character models from [Synty](https://syntystore.com/).*

1. Import the GLB file, [explosive_bone_map.tres](https://github.com/scotmcp/explosive.ws-to-godot/blob/main/scripts/explosive_bone_map.tres "explosive_bone_map.tres") and the [explosive_bone_map.tres](https://github.com/scotmcp/explosive.ws-to-godot/blob/main/scripts/explosive_bone_map.tres "explosive_bone_map.tres") file to the project by dragging them into the Res:// filesystem frame.

2. Select the GLB file in Godot FileSystem and open the Import tab above the Scene Tree.

3. Change **Import As:** to Animation Library and click the **Reimport** button at the bottom of the frame. *Note: this step sometimes happens quickly, sometimes it takes a while. Be patient.*

4. Click on **Advanced...** button.

5. Select the Skeleton3D in the Scene Tree on the left, and in the inspector under **Retarget** assign the explosive_bone_map.tres as the skeleton.

6. Click on **Reimport** *Note: this step sometimes happens quickly, sometimes it takes a while. Be patient.*

7. Once importing is complete, go back to the Import Tab and assign **explosive_anim_import.gd** as the import script, and click on **Reimport**.

8. Verify the animation was imported correctly by adding the library to the animation player, testing each animation out.

# Job Done !!
