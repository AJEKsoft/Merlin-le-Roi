extends Control 

var is_player_turn = true
var turn_number = 0

signal player_turn_started
signal player_turn_ended
signal player_illegal_action

var dungeon : Node3D
var player : Player

func _ready():
	dungeon = find_child("Exploration").get_node("Dungeon")
	player = find_child("Player")
	player_turn_started.emit()

func _on_player_update_mana(maxv: int, current: int):
	find_child("player-mana-bar").new_value(current)
	find_child("player-mana-bar").set_max_value(maxv)

func _on_player_update_health(maxv: int, current: int):
	find_child("player-health-bar").new_value(current)
	find_child("player-health-bar").set_max_value(maxv)

func _on_player_damaged(damage: int):
	find_child("player-health-bar").reduce_value(damage)

func _on_player_lost_mana(value: int):
	find_child("player-mana-bar").reduce_value(value)


func _on_turn_timer_timeout():
	end_player_turn()

func _on_player_turn_started():
	turn_number += 1
	print("Turn ", turn_number, " started")
	$TurnTimer.start()
	$PlayerTurnStarted.play()

func _on_player_turn_ended():
	$PlayerTurnEnded.play()
	#TODO: obviously, this should be replaced by AI actions
	begin_player_turn()

func _on_player_request_move(target : Vector2i):
	if not is_player_turn:
		player_illegal_action.emit()
		return
	var tile = dungeon.get_tile_at(target)
	if tile == null or tile == "ExitPortal":
		print("Player moving from ", player.grid_position, " to ", target)
		player.move_to(target)

func _on_player_enter_tile(tile_pos : Vector2i):
	var tile = dungeon.get_tile_at(tile_pos)
	if tile == "ExitPortal":
		print("Player entered exit portal")
		get_tree().change_scene_to_file("res://scenes/end_level.tscn")
	end_player_turn()

func _on_player_action():
	if not is_player_turn:
		player_illegal_action.emit()
		return
	print("Player at ", player.grid_position, " action on tile ", player.get_forward_cell_position())
	# We check the tile right in front of the player
	var forward_position = player.get_forward_cell_position()
	var tile = dungeon.get_tile_at(forward_position)
	forward_position = Vector3i(forward_position.x, 0, forward_position.y)
	# if the tile is a door, we open it
	if tile == "Door":
		dungeon.find_child("Walls").set_cell_item(forward_position, -1)
		$DoorSound.play()
		end_player_turn()

func end_player_turn():
	print("Turn ended")
	is_player_turn = false
	player_turn_ended.emit()

func begin_player_turn():
	is_player_turn = true
	player_turn_started.emit()

func _on_player_death():
	pass # Replace with function body.
