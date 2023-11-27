extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	resized.connect(_on_resized)
	_on_resized()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resized():
	var viewport_size = get_viewport().size
	$ExplorationViewport/SubViewport.size = Vector2i(2*viewport_size.x / 3, viewport_size.y)
	$HUD/SpellTable.position = Vector2i($ExplorationViewport/SubViewport.size.x, 0)
	$HUD/SpellTable.place_runes()
