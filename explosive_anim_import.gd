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



# ratio difference of leg length different between explosive.ws animation rigs and standard humanoid rigs.
var keyframe_mod_ratio : float = 0.12

var animation_player : AnimationPlayer
var animation : Animation



# This sample changes all node names.
# Called right after the scene is imported and gets the root node.
func _post_import(scene):
	# Collection all animations into an array
	
	for child in scene.get_children():
		if child is AnimationPlayer:
			animation_player = child
			for anim_name in animation_player.get_animation_list():
				var animation = animation_player.get_animation(anim_name)
				iterate(animation, anim_name)
	return scene # Remember to return the imported scene

func iterate(animation, anim_name):
	adjust_keyframes(animation, anim_name)
	#print(animation)
			

# Adjust the Hip bone placement so that it lines up with the Hip Bone on standard humanoid rigs.
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
		if anim_name == "RelaxIdle":
			print("Original Keyframe Value: " + str(keyframe_value))
			var keyframe_mod : float = keyframe_value.y * keyframe_mod_ratio
			keyframe_value.y -= keyframe_mod
			animation.track_set_key_value(track_index, i, keyframe_value)
			print("Modified Keyframe Value: " + str(keyframe_value))
			
			
			
