extends Area2D

signal rune_selected(rune:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$image.texture = load("res://runes/png/" + self.name + ".png")
	$image.scale = Vector2(0.5, 0.5)

	# Set the size of the collision shape to coincide with the image
	$collision.shape.radius = $image.texture.get_width() * $image.scale.x / 2
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func unselect():
	$image/background.visible = false

func _on_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and $image/background.visible == false:
			$image/background.visible = true
			emit_signal("rune_selected", self.name)
	pass # Replace with function body.
