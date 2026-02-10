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

# --- Settings ---
folder_path = "D:\\Assets\\RPG GLB\\Climbing-Ladder"
rotate_z = True 
remove_root_motion = True  # Set to True to stay in place, False to keep movement
remove_mesh = False 
weapon = "Crossbow"

if not os.path.isdir(folder_path):
    print(f"Error: '{folder_path}' is not a valid directory.")
else:
    for filename in os.listdir(folder_path):
        if not filename.endswith(".FBX"):
            continue

        # 1. CLEAN THE SCENE
        # Deleting everything ensures the next import is always "Armature" and "Motion"
        bpy.ops.object.select_all(action='SELECT')
        bpy.ops.object.delete() 
        for block in bpy.data.actions:
            if block.users == 0: bpy.data.actions.remove(block)

        file_path = os.path.join(folder_path, filename)
        
        # 2. IMPORT
        bpy.ops.import_scene.fbx(
            filepath=file_path, 
            automatic_bone_orientation=True,
            use_prepost_rot=True 
        )

        # 3. IDENTIFY ARMATURE AND ACTION
        armature = bpy.data.objects.get("Armature")
        
        if armature and armature.animation_data and armature.animation_data.action:
            action = armature.animation_data.action
            
            # 4. REMOVE ROOT MOTION (If toggled)
            if remove_root_motion:
                # We iterate backwards [:] to safely remove items while looping
                for fcurve in action.fcurves[:]:
                    # Target both 'Motion' bone data paths and Object-level 'Motion' paths
                    if "Motion" in fcurve.data_path and "location" in fcurve.data_path:
                        action.fcurves.remove(fcurve)
                print(f"Root motion removed for {filename}")

            # 5. ROTATION FIX
            if rotate_z:
                armature.rotation_euler[2] = math.radians(180)
                # Apply rotation so the 'Motion' keys align with the new forward
                bpy.ops.object.transform_apply(location=False, rotation=True, scale=False)

            # 6. RENAME ACTION
            new_name = os.path.splitext(filename)[0].replace("RPG-Character@", "").replace("-", "")
            action.name = new_name
            action.use_fake_user = True

        # 7. CLEANUP EXTRA OBJECTS
        for obj in bpy.data.objects:
            if weapon in obj.name or (remove_mesh and "Mesh" in obj.name):
                bpy.data.objects.remove(obj, do_unlink=True)

        print(f"Processed: {action.name}")

print("Done!")
