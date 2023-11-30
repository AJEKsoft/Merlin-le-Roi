@tool
extends Container

@export var radius = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	place_elements()
	
func place_elements():
	var elements = get_children()
	if elements.size() == 0:
		return

	var centre = self.size / 2 - Vector2(radius / 2, radius / 2)

	var angle_offset = (2*PI) / elements.size()	
	var angle = 0
	for element in elements:
		element.position = centre - Vector2(radius, 0).rotated(angle)
		angle += angle_offset
