extends Node3D

var level
signal trigger_combat

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Begin exploration of level", LevelState.current_level)
	level = load("res://levels/level"+str(LevelState.current_level)+".tscn").instantiate()
	add_child(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_trigger_combat():
	PlayerState.current_scene = self
	var combat_intro = load("res://scenes/combat_intro.tscn").instantiate()
	get_tree().root.add_child(combat_intro)
	get_tree().set_current_scene(combat_intro)
	get_tree().root.remove_child(self)


func _on_player_action():
	print("Player at ", $Player.grid_position, " action on tile ", $Player.get_forward_cell_position())
	# We check the tile right in front of the player
	var forward_position = $Player.get_forward_cell_position()
	forward_position = Vector3i(forward_position.x, 0, forward_position.y)
	var tile = level.find_child("Walls").get_cell_item(forward_position)
	# if the tile is a door, we open it
	if tile == 3:
		level.find_child("Walls").set_cell_item(forward_position, -1)
		trigger_combat.emit()

func _on_player_request_move(target : Vector2i):
	var tile = level.find_child("Walls").get_cell_item(Vector3i(target.x, 0, target.y))
	if tile == -1:
		print("Player moving from ", $Player.grid_position, " to ", target)
		$Player.move_to(target)

func _on_player_enter_tile():
	pass # Replace with function body.
