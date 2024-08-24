## Script Created by Scot McPherson:
## https://www.youtube.com/channel/UCNDREeLwXewcJzyiMYF9kMA
##
## Original Script Created by MissingLinkDev:
## https://www.youtube.com/channel/UCnPYqCSU-CFppoufb7BKuAg
##
## You can buy explosive.ws animations for godot here:
## https://www.explosive.ws/products/rpg-animation-fbx-for-godot-blender



## Todo:
##  List of animation libraries that need to have their Rotation X set to 0 and Rotation Applied
##  2h Crossbow
##  2h Spear
##  2h Sword
##  Armed_Shield
##  Climbing-Ladder
##  Climbing-Ledge
##  Crawl
##  Swimming

## explosive version 0.0.6 and earlier, this is already fixed in future versions
##  Crouch Walk Left - Delete Pelvis X Motion

import bpy
import os
import math


# linux example path
folder_path = "/home/scot/godot/Assets/Animations/ExplosiveLLC/RPG Animation FBX-0.0.6/Relax"

# windows example path
#folder_path =  "C:\\Users\\Scot\\Animations\\ExplosiveLLC\\RPG Animation FBX-0.0.0\\Relax"


# Setup some variables
rotate_z = True # rotate the animation by 180 on Z
remove_root_motion = True # remove the root motion location fcurves from animations, root rotation and root scale fcurves are not removed.

remove_mesh = False # Experimental: remove the final mesh inside the armature that causes warnings in Godot
weapon = "Crossbow"  # Name of weapon in case it exists in anim (it shouldn't)

# Setup the environment
collection = bpy.data.collections.get("Collection") # Starting Cube and it's Collection
#bpy.ops.wm.read_factory_settings(use_empty=True) # Reset to default startup environment


if not os.path.isdir(folder_path):
    print(f"Error: '{folder_path}' is not a valid directory.")

else:

    # Delete the starting cube and collection
    if collection is not None:
        # Iterate over all objects in the collection and unlink them
        for obj in collection.objects:
            bpy.data.objects.remove(obj, do_unlink=True)
        
        # Remove the collection itself
        bpy.data.collections.remove(collection)
        
    # Search Folder for FBX files.
    for filename in os.listdir(folder_path):
        if not filename.endswith(".FBX"):
            continue

        file_path = os.path.join(folder_path, filename)
        print(file_path)
        # Import the file
        bpy.ops.import_scene.fbx(filepath=file_path, automatic_bone_orientation=True)

        # Look for weapon name and remove it
        for object in bpy.context.scene.objects:
            if object.name == weapon:
                mesh_object = bpy.data.objects[weapon] 
                
                # Delete the mesh object.
                bpy.data.objects.remove(mesh_object)
                
                # Get the action to delete.
                action = bpy.data.actions[weapon + "|Take 001|BaseLayer"]
                
                # Delete the action.
                bpy.data.actions.remove(action)

        # Get the action
        action = None
        obj = bpy.context.selected_objects[0]
        if obj.animation_data:
            action = obj.animation_data.action
            
            # Remove root motion fcurves
            if remove_root_motion:
                for fcurve in obj.animation_data.action.fcurves:
                    if "Motion" in fcurve.data_path and "location" in fcurve.data_path:
                            action.fcurves.remove(fcurve)

        if not action:
            print(f"Warning: '{filename}' doesn't contain an animation.")
            continue

        # Rename the action, this removes the first part of the file name so just the action is left
        # Update "RPG-Character@Unarmed-" with the prefix to be removed
        action.name = os.path.splitext(filename)[0].replace("RPG-Character@", "").replace("-", "")

        # Delete all but the first armature and first mesh
        for object in bpy.context.scene.objects:
            if object.name == "Armature.001" or object.name == "RPG-Character-Mesh.001":
                bpy.data.objects.remove(object)

            # If True then delete final mesh
            elif object.name == "RPG-Character-Mesh":
                if remove_mesh == True:
                    bpy.data.objects.remove(object)
                

        # Rotate the animation to face 180 degrees Z so it faces forward in godot
        if rotate_z == True:
            rot_obj = bpy.data.objects["Armature"]
            rot_obj.select_set(True)
            rot_obj.rotation_euler = [math.radians(90), 0.0, math.radians(180)]
            bpy.context.view_layer.update()
           

        
        print(f"Imported and renamed animation action for '{filename}' to '{action.name}'")
        
        
    # Export File
    #bpy.ops.export_scene.glb(filepath=export_file_path, export_selected=False)

print("Done!")
