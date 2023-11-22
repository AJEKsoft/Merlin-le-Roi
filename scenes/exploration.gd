extends Node3D

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	level = load("res://levels/level"+str(LevelState.current_level)+".tscn").instantiate()
	add_child(level)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_trigger_combat():
	PlayerState.current_scene = get_tree().get_current_scene().duplicate()
	get_tree().change_scene_to_file("res://scenes/combat_intro.tscn")
