extends Control 


func _ready():
	self.scale = Vector2(float(get_viewport().size.x) / 854., float(get_viewport().size.y / 480.))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
