extends Area3D

class_name Monster

# references to UI elements describing the monster
var health_progress = null 

@export var attributes : MonsterAttributes

signal attack(value: int)
signal death
signal health_changed(value: int)

var health : int
var mana : int
var attack_timer : Timer = Timer.new()
var death_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()
var hurt_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()
var attack_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()
var grid_position : Vector2i = Vector2i(0, 0)
var grid_target : Vector2i = Vector2i(0, 0)
# smooth rotation variables
var rotated = 0 # in radians, how much we have rotated
var rotated_target : float = 0 # in degrees
var current_rotation : float = 0
var grid_lookat : Vector2i = Vector2i(0, -1)
var rotation_speed = .3 # seconds to complete the movement
var is_rotating = false

# smooth movement variables
var moved = 0 # in meters, how much we have moved
var movement_speed = .3 # seconds to complete the movement
var is_moving = false

signal enter_tile(tile:Vector2i)
signal action 
signal request_move(target:Vector2i)

func _ready():
	attack_timer.timeout.connect(_on_attack_timeout)
	attack_timer.autostart = true
	health = attributes.max_health
	mana = attributes.max_mana
	connect_to_bars()

func connect_to_bars():
	health_progress = find_child("health-bar")
	health_progress.set_max_value(attributes.max_health)
	health_progress.new_value(health)
	find_child("name").set_text(self.name)
	add_child(attack_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = min(health + attributes.health_regen_rate * delta, attributes.max_health)
	mana = min(mana + attributes.mana_regen_rate * delta, attributes.max_mana)
	health_progress.new_value(health)
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
			position = Vector3(intermediate_position.x, 0, intermediate_position.y)

func _on_attacked(damage : int):
	health -= damage
	health_progress.reduce_value(damage)
	if health <= 0:
		death_sound_player.play()
		emit_signal("death")
		queue_free()
	else:
		hurt_sound_player.play()

func _on_attack_timeout():
	attack_sound_player.play()
	emit_signal("attack", attributes.strength)


func _on_death():
	queue_free()

func get_forward_cell_position() -> Vector2i:
	return grid_position - grid_lookat

func get_backward_cell_position() -> Vector2i:
	return grid_position + grid_lookat

func get_left_cell_position() -> Vector2i:
	return grid_position + Vector2i(-grid_lookat.y, grid_lookat.x)

func get_right_cell_position() -> Vector2i:
	return grid_position + Vector2i(grid_lookat.y, -grid_lookat.x)

func get_right() -> Vector2i:
	return Vector2i(grid_lookat.y, grid_lookat.x)

func get_left() -> Vector2i:
	return Vector2i(-grid_lookat.y, grid_lookat.x)

# starts a smooth movement
func move_to(val: Vector2i):
	grid_target = val
	moved = 0
	is_moving = true

func place_at(val: Vector2i):
	grid_position = val
	grid_target = val
	moved = 0
	position = Vector3(val.x, 0, val.y)

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
