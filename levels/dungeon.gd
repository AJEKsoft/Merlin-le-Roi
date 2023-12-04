extends Node3D

class_name Dungeon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_tile_at(pos : Vector2i):
	var tile_no = $Walls.get_cell_item(Vector3i(pos.x, 0, pos.y))
	if tile_no == -1:
		return null
	else:
		return $Walls.mesh_library.get_item_name(tile_no)