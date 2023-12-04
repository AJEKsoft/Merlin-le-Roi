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

	var position_offset = Vector2(radius, radius)
	
	# Since runes are of equal size (at least for now), this will do.
	# However, a RadialContainer should be rather universal...
	self.size = position_offset * Vector2(2, 2) + elements[0].size
	
	var angle_offset = (2*PI) / elements.size()	
	var angle = 0
	for element in elements:
		element.position = position_offset + Vector2(radius, 0).rotated(angle)
		angle += angle_offset
