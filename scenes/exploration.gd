extends Node3D

var level : Dungeon
var turn = "player"
var turn_blocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Begin exploration of level", LevelState.current_level)
	level = load("res://levels/level"+str(LevelState.current_level)+".tscn").instantiate()
	level.name = "Dungeon"
	add_child(level)
	$Player.place_at(Vector2i(0, 0))
