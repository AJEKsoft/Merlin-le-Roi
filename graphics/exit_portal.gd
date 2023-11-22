extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area:Area3D):
	if area is Player:
		LevelState.current_level += 1
		print("Level completed")
		print(LevelState.current_level)
		get_tree().change_scene_to_file("res://scenes/end_level.tscn")
