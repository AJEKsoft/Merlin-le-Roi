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


func _on_player_action():
	print("player action")
	# We check the tile right in front of the player
	var forward_position = $Player.get_forward_cell_position()
	forward_position = Vector3i(forward_position.x, 0, forward_position.y)
	var tile = level.find_child("Walls").get_cell_item(forward_position)
	print("tile: " + str(tile))
	# if the tile is a door, we open it
	if tile == 3:
		level.find_child("Walls").set_cell_item(forward_position, -1)
	pass # Replace with function body.

func _on_player_request_move(target : Vector2i):
	var tile = level.find_child("Walls").get_cell_item(Vector3i(target.x, 0, target.y))
	if tile == -1:
		$Player.move_to(target)
