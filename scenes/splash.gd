extends Node2D

func _process(delta):
	if Input.is_action_pressed("skip_scene"):
		next_scene()

func next_scene():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name:StringName):
	next_scene()
