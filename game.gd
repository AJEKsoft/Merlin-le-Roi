extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport_rect().size
	$ExplorationViewport/SubViewport.size = Vector2i(viewport_size.x / 2, viewport_size.y)
	$HUDViewport/SubViewport.size = Vector2i(viewport_size.x / 2, viewport_size.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
