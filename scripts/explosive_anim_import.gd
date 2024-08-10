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

var animation_player : AnimationPlayer
var animation : Animation

## ratio difference of leg length different between explosive.ws animation rigs and Synty humanoid rigs.
## This ratio should be 0.115, but feel free to test and adjust as needed.
var synty : bool = false
var keyframe_mod_ratio : float = 0.115


## Called right after the scene is imported and gets the root node and iterates through each animation in the library
func _post_import(scene):
	# Collection all animations into an array
	
	for child in scene.get_children():
		if child is AnimationPlayer:
			animation_player = child
			for anim_name in animation_player.get_animation_list():
				var animation = animation_player.get_animation(anim_name)
				iterate(animation, anim_name)
	return scene # Remember to return the imported scene

func iterate(animation, anim_name) -> void:
	if synty:
		adjust_keyframes(animation, anim_name)
	set_loop_mode(animation, anim_name)
	print("Animation: " + str(anim_name) + " processing processing complete")
	

## Adjust the Hip bone placement so that it lines up with the Hip Bone on standard humanoid rigs.
func adjust_keyframes(animation: Animation, anim_name) -> void:
	var track_index
	#track_index = animation.find_track("Armature/Skeleton3D:B_Pelvis", Animation.TYPE_POSITION_3D)
	track_index = animation.find_track("%GeneralSkeleton:Hips", Animation.TYPE_POSITION_3D)
	var track_name = animation.track_get_path(track_index)
	var keyframe_count = animation.track_get_key_count(track_index)
	
	#print("Animation Name: " + str(anim_name) + " Track Name: " + str(track_name) + " Track Number: " + \
		 #str(track_index) + " Keyframe Count: " + str(keyframe_count))
	
	for i in range(keyframe_count):
		var keyframe_time = animation.track_get_key_time(track_index, i)
		var keyframe_value = animation.track_get_key_value(track_index, i)
		
		#if anim_name == "RelaxIdle":
			#print("Original Keyframe Value: " + str(keyframe_value))
		var keyframe_mod : float = keyframe_value.y * keyframe_mod_ratio
		keyframe_value.y -= keyframe_mod
		animation.track_set_key_value(track_index, i, keyframe_value)
			#print("Modified Keyframe Value: " + str(keyframe_value))
		print("Animation Keyframes adjusted")
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
	pass
	
			
			

