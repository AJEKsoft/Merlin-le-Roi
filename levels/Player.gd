extends Area3D 

class_name Player

# smooth rotation variables
var rotated = 0 # in radians, how much we have rotated
var rotation_speed = .3 # seconds to complete the movement
var is_rotating = false

# smooth movement variables
var moved = 0 # in meters, how much we have moved
var movement_speed = .3 # seconds to complete the movement
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

signal enter_tile(tile:Vector2i)
signal action 
signal request_move(target:Vector2i)

var grid_position : Vector2i = Vector2i(0, 0)
var grid_target : Vector2i = Vector2i(0, 0)
var rotated_target : float = 0 # in degrees
var current_rotation : float = 0
var grid_lookat : Vector2i = Vector2i(0, -1)

# starts a smooth movement
func move_to(val: Vector2i):
	grid_target = val
	moved = 0
	is_moving = true

func place_at(val: Vector2i):
	grid_position = val
	grid_target = val
	moved = 0
	position = Vector3(val.x, .5, val.y)

func rotate_to(val : float):
	rotated_target = val
	rotated = 0
	is_rotating = true
	if val < 0:
		val += 360
	if val >= 360:
		val -= 360

func set_lookat(val : float):
	rotated_target = val
	current_rotation = val
	while val < 0:
		val += 360
	while val >= 360:
		val -= 360
	if val == 0:
		grid_lookat = Vector2i(0, -1)
	elif val == 90:
		grid_lookat = Vector2i(-1, 0)
	elif val == 180:
		grid_lookat = Vector2i(0, 1)
	elif val == 270:
		grid_lookat = Vector2i(1, 0)
	else:
		print("ERROR: invalid rotation")
	self.rotation_degrees = Vector3(0, val, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_rotating:
		rotated += delta / rotation_speed
		if rotated >= 1:
			set_lookat(rotated_target)
			is_rotating = false
		else:
			# interpolate between current rotation and target rotation
			var intermediate_rotation = current_rotation + (rotated_target - current_rotation) * rotated
			self.rotation_degrees = Vector3(0, intermediate_rotation, 0)

	if is_moving:
		moved += delta / movement_speed
		if moved >= 1:
			place_at(grid_target)
			is_moving = false
			enter_tile.emit(grid_target)
		else:
			# interpolate between current position and target position
			var intermediate_position = Vector2(grid_position.x, grid_position.y) + (Vector2(grid_target.x, grid_target.y) - Vector2(grid_position.x, grid_position.y)) * moved
			position = Vector3(intermediate_position.x, .5, intermediate_position.y)

	if not (is_moving or is_rotating):
		if Input.is_action_pressed("dungeon_move_forward"):
			request_move.emit(get_forward_cell_position())
		if Input.is_action_pressed("dungeon_move_backward"):
			request_move.emit(get_backward_cell_position())
		if Input.is_action_pressed("dungeon_turn_left"):
			rotate_to(current_rotation + 90)
		if Input.is_action_pressed("dungeon_turn_right"):
			rotate_to(current_rotation - 90)
		if Input.is_action_just_pressed("dungeon_action"):
			action.emit()

func get_forward_cell_position() -> Vector2i:
	return grid_position + grid_lookat

func get_backward_cell_position() -> Vector2i:
	return grid_position - grid_lookat

func get_left_cell_position() -> Vector2i:
	return grid_position + Vector2i(-grid_lookat.y, grid_lookat.x)

func get_right_cell_position() -> Vector2i:
	return grid_position + Vector2i(grid_lookat.y, -grid_lookat.x)

func get_right() -> Vector2i:
	return Vector2i(grid_lookat.y, -grid_lookat.x)

func get_left() -> Vector2i:
	return Vector2i(-grid_lookat.y, grid_lookat.x)


func _on_spell_table_cast_spell(spell:Spell):
	spell.transform = $spellStart.global_transform
	owner.add_child(spell)
