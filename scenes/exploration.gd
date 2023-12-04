extends Node3D

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Begin exploration of level", LevelState.current_level)
	level = load("res://levels/level"+str(LevelState.current_level)+".tscn").instantiate()
	level.name = "Dungeon"
	add_child(level)
	$Player.place_at(Vector2i(0, 0))
	$Dungeon.find_child("PlayerRemoteTransform").remote_path = $Player.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerfollow = $Dungeon.find_child("PlayerFollow")
	if playerfollow.progress_ratio < 0.99:
		playerfollow.progress += delta

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
		$DoorSound.play()

func _on_player_request_move(target : Vector2i):
	var tile = get_tile_at(target)
	if tile == null or tile == "ExitPortal":
		print("Player moving from ", $Player.grid_position, " to ", target)
		$Player.move_to(target)

func _on_player_enter_tile(tile_pos : Vector2i):
	var tile = get_tile_at(tile_pos)
	if tile == "ExitPortal":
		print("Player entered exit portal")
		get_tree().change_scene_to_file("res://scenes/end_level.tscn")
