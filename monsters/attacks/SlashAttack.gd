extends Node3D

@export var damage : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_timer_timeout():
	queue_free()

func _on_effect_area_area_entered(area:Area3D):
	if area != owner and area is Monster:
		area._on_attacked(self.damage)
