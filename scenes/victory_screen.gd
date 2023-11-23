extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_continue_button_pressed():
	get_tree().get_current_scene().queue_free()
	get_tree().get_root().add_child(PlayerState.current_scene)
	get_tree().set_current_scene(PlayerState.current_scene)
