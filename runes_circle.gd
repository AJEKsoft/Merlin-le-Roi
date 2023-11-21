extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	for rune in get_children():
		# draw a line from the center to the rune
		draw_line(Vector2(0, 0), rune.position, Color(1, 1, 1), 1, true)
	# get sequence from parent
	var sequence = get_parent().current_sequence
	# draw a line from each rune to the next, and to the mouse cursor
	if sequence.size() > 0:
		var firstRune = find_child(sequence[0])
		var color = firstRune.find_child("image").modulate
		var thickness = 10 * sequence.size()
		for i in range(sequence.size() - 1):
			var runeA = find_child(sequence[i])
			var runeB = find_child(sequence[i + 1])
			draw_line(runeA.position, runeB.position, color, thickness, true)
		var lastRune = find_child(sequence[sequence.size() - 1])
		draw_line(lastRune.position, to_local(get_viewport().get_mouse_position()), color, thickness, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
