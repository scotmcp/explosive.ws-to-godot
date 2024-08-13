@tool # Needed so it runs in editor.
extends EditorScenePostImport

## Written by: Scot McPherson
## Date: Aug 9, 2024
##
## Explosive.ws animations are rigged with slightly longer legs. They are compatible for retargetting
## in godot with standard humanoid rigs applied to a character mesh, but they need a slight adjustment
## to the placement of the Hips bone. This script makes those changes.
##
## Please read the readme.md file for instructions
## You can buy and download Explosive.ws animations for godot from:
## https://www.explosive.ws/products/rpg-animation-fbx-for-godot-blender

var resource = Resource.new()

var test : bool = true
var animation_player : AnimationPlayer

## ratio difference of leg length different between explosive.wss animation rigs and Synty humanoid rigs.
## This ratio should be 0.115, but feel free to test and adjust as needed.s
var synty : bool = true
var keyframe_mod_ratio : float = 0.115

var config = ConfigFile.new()


## Called right after the scene is imported and gets the root node and iterates through each animation in the library
func _post_import(scene):
	#set_skeleton() # return to this once bugs have been fixed in Godot https://github.com/godotengine/godot/issues/95461
	for child in scene.get_children():
		if child is AnimationPlayer:
			animation_player = child
			for anim_name in animation_player.get_animation_list():
				var animation = animation_player.get_animation(anim_name)
				iterate(animation, anim_name)
	print("*** Animation processing completed for All Animations ***")
	return scene
	
func iterate(animation, anim_name) -> void:
	if synty:
		adjust_keyframes(animation, anim_name)
	set_loop_mode(animation, anim_name)
	print("Animation: " + str(anim_name) + " processing processing complete")


	
## Adjust the Hip bone placement so that it lines up with the Hip Bone on standard humanoid rigs.
func adjust_keyframes(animation: Animation, anim_name) -> void:
	print("Begin Keyframe Adjustments for :" + anim_name)
	var track_index
	#track_index = animation.find_track("Armature/Skeleton3D:B_Pelvis", Animation.TYPE_POSITION_3D)
	track_index = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
	var track_name = animation.track_get_path(track_index)
	var keyframe_count = animation.track_get_key_count(track_index)
	for i in range(keyframe_count):
		var keyframe_time = animation.track_get_key_time(track_index, i)
		var keyframe_value = animation.track_get_key_value(track_index, i)
		var keyframe_mod : float = keyframe_value.y * keyframe_mod_ratio
		keyframe_value.y -= keyframe_mod
		animation.track_set_key_value(track_index, i, keyframe_value)
	print("Completed Keyframe Adjustments for :" + anim_name)
		
		
## Set linear loop mode animation names that contain:
## "idle", "fall", "loop", "run", "sprint", "strafe", "stunned", "walk"
## but not "Loop-Start" or "Loop-End"
func set_loop_mode(animation, anim_name) -> void:
	if "idle" in anim_name or "Idle" in anim_name or \
		"fall" in anim_name or "Fall" in anim_name or \
		"loop" in anim_name or "Loop" in anim_name or \
		"run" in anim_name or "Run" in anim_name or \
		"sprint" in anim_name or "Sprint" in anim_name or \
		"strafe" in anim_name or "Strafe" in anim_name or \
		"stunned" in anim_name or "Stunned" in anim_name or \
		"walk" in anim_name or "Walk" in anim_name:
			if "loop-end" in anim_name or "Loop-End" in anim_name or \
				"loop-start" in anim_name or "Loop-Start" in anim_name:
				return
			else:
				animation.loop_mode = animation.LOOP_LINEAR
			print("Updated loop mode for animation: ", anim_name)

	# Notify the user that the process is complete
	print("Animation loop mode update complete.")


## return to this once bugs have been fixed in Godot https://github.com/godotengine/godot/issues/95461
func set_skeleton() -> void:
	print("*** Set BoneMap ***")
	var bone_map : BoneMap = load("res://explosive_bone_map.tres")
	var rest_pose : Animation = load("res://T-Pose.fbx")
	var err : Error = config.load("res://relax.glb.import")
	print(err)
	print(config.get_value("params", "_subresources"))
	
	
	var rest_pose_node : Dictionary = {"nodes" : {"PATH:Armature/Skeleton3D": {"rest_post/external_animation_library": null}}}
	config.set_value("params", "_subresources", rest_pose_node)
	
	#var bone_map_node : Dictionary = {"nodes" : {"PATH:Armature/Skeleton3D": {"retarget/bone_map": bone_map}}}
	#config.set_value("params", "_subresources", bone_map_node)
	
	config.save("res://relax.glb.import")
	
	##config.load("res://relax.glb.import")
	
	print("subresource = " + str(config.get_value("params", "_subresources")))
	#print("nodes = " + str(bone_map_node))
			
	config.save("res://relax.glb.import.txt")
	print("*** BoneMap Set Complete ***")
	
