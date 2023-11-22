extends Node3D

var initial_room_size = 2
var dungeon_size = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_random()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_random():
	for i in range(0, 100):
		var x = randi() % dungeon_size - dungeon_size / 2
		var z = randi() % dungeon_size - dungeon_size / 2
		# don't spawn near the middle
		if x > initial_room_size / 2 and z > initial_room_size / 2:
			continue
		if x < -initial_room_size / 2 and z < -initial_room_size / 2:
			continue
		var mesh = MeshInstance3D.new()
		var cube = BoxMesh.new()
		mesh.mesh = cube
		mesh.position = Vector3(x, .5, z)
		$walls.add_child(mesh)
