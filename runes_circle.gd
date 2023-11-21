extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
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

func _process(_delta):
	queue_redraw()
	if get_parent().current_sequence.size() > 0:
		$LinkParticles.process_material.color = find_child(get_parent().current_sequence[0]).find_child("image").modulate
		$LinkParticles.emitting = true
		$LinkParticles.position = to_local(get_viewport().get_mouse_position())
	else:
		$LinkParticles.emitting = false
