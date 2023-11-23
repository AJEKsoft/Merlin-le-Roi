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

func get_tile_at(pos : Vector2i):
	var tile_no = level.find_child("Walls").get_cell_item(Vector3i(pos.x, 0, pos.y))
	if tile_no == -1:
		return null
	else:
		return level.find_child("Walls").mesh_library.get_item_name(tile_no)

func _on_player_action():
	print("Player at ", $Player.grid_position, " action on tile ", $Player.get_forward_cell_position())
	# We check the tile right in front of the player
	var forward_position = $Player.get_forward_cell_position()
	var tile = get_tile_at(forward_position)
	forward_position = Vector3i(forward_position.x, 0, forward_position.y)
	# if the tile is a door, we open it
	if tile == "Door":
		level.find_child("Walls").set_cell_item(forward_position, -1)
		trigger_combat.emit()

func _on_player_request_move(target : Vector2i):
	var tile = get_tile_at(target)
	if tile == null or tile == "ExitPortal":
		print("Player moving from ", $Player.grid_position, " to ", target)
		$Player.move_to(target)

func _on_player_enter_tile(tile_pos : Vector2i):
	var tile = get_tile_at(tile_pos)
	if tile == "ExitPortal":
		print("Player entered exit portal")
		LevelState.current_level += 1
		get_tree().change_scene_to_file("res://scenes/end_level.tscn")
