extends Camera3D

# smooth rotation variables
var rotated = 0 # in radians, how much we have rotated
var rotate_direction = 1 # -1 for clockwise, 1 for counterclockwise
var rotation_speed = PI # rad/s
var is_rotating = false

# smooth movement variables
var moved = 0 # in meters, how much we have moved
var move_direction = 1 # 1 for backwards, -1 for forwards
var movement_speed = 3 # m/s
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_rotating:
		var delta_rot = rotation_speed * delta
		rotated += delta_rot
		if rotated >= PI/2: # we have over-rotated
			delta_rot -= rotated - PI/2
			is_rotating = false
		rotation.y += delta_rot * rotate_direction

	if is_moving:
		var delta_move = movement_speed * delta
		moved += delta_move
		if moved >= 1: # we have over-moved
			delta_move -= moved - 1
			is_moving = false
		var forward = Vector3(0, 0, 1) * delta_move * move_direction
		translate(forward)		

	if Input.is_action_just_pressed("dungeon_move_forward") and not is_moving:
		is_moving = true
		moved = 0
		move_direction = -1	
	if Input.is_action_just_pressed("dungeon_move_backward"):
		is_moving = true
		moved = 0
		move_direction = 1
	if Input.is_action_just_pressed("dungeon_turn_left") and not is_rotating:
		is_rotating = true
		rotated = 0
		rotate_direction = 1
	if Input.is_action_just_pressed("dungeon_turn_right") and not is_rotating:
		is_rotating = true
		rotated = 0
		rotate_direction = -1