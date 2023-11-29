extends TextureProgressBar

class_name BetterProgress

var value_delta = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.get_children())
	$progress.tint_progress = self.tint_progress
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.value -= value_delta * delta
	if self.value < $progress.value:
		self.value = $progress.value
		value_delta = 0

func reduce_value(v: float):
	value_delta = v
	$progress.value -= v

func new_value(v: float):
	$progress.value = v

func set_max_value(v: float):
	$progress.max_value = v
	self.max_value = v
