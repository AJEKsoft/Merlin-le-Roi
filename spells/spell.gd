extends Area3D
class_name Spell

@export var velocity : int = 5
@export var damage : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.basis.z * delta * velocity

	if position.length() > 1000:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area:Area3D):
	if area is Monster:
		area._on_attacked(self.damage)
		queue_free()
	else:
		print(area)
