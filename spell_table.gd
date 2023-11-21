extends Node2D
class_name SpellTable

var current_sequence = []
var spells = {
	"virgo" : {
		"pisces" : "heal"
	},
	"taurus" : {
		"gemini" : "shield"
	},
	"aries" : {
		"leo" : {
			"sagittarius" : "fireball"
		}
	}
}

signal begin_spell
signal continue_spell
signal cast_spell(spell:String)
signal wrong_spell

@export var rotation_speed : float = 1 # rotations per minute
var radius = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	place_runes()

func _process(delta : float):
	var angular_speed = rotation_speed * 2 * PI / 60 # radians per second
	$runes_circle.rotate(delta * angular_speed)
	for rune in $runes_circle.get_children():
		rune.rotate(-delta * angular_speed)
func _draw():
	# draw a circle behind the runes
	draw_arc($runes_circle.position, radius, 0, 2*PI, 64, Color(1,1,1,0.5), 2)

# Place the runes evenly spaced around a circle
func place_runes():
	var total_runes = $runes_circle.get_child_count()
	var angle_increment = 2*PI / total_runes

	$runes_circle.position = get_viewport_rect().size/2
	for i in range(total_runes):
		var rune = $runes_circle.get_child(i)
		var x = radius * cos(angle_increment * i)
		var y = radius * sin(angle_increment * i)
		rune.position = Vector2(x, y) 

func check_sequence():
	var current_spell = spells
	for rune in current_sequence:
		if current_spell.has(rune):
			current_spell = current_spell[rune]
		else:
			current_spell = null
			reset_sequence()
			emit_signal("wrong_spell")
	if typeof(current_spell) == TYPE_STRING:
		reset_sequence()
		emit_signal("cast_spell", current_spell)
	elif typeof(current_spell) == TYPE_DICTIONARY:
		pass
	else:
		reset_sequence()
		emit_signal("wrong_spell")

func reset_sequence():
	current_sequence = []
	for rune in $runes_circle.get_children():
		rune.unselect()

func _on_rune_selected(rune:String):
	if current_sequence.size() == 0:
		emit_signal("begin_spell")
	else:
		emit_signal("continue_spell")
	current_sequence.append(rune)
	check_sequence()

func _on_wrong_spell():
	$sequence_fail.play()

func _on_continue_spell():
	$sequence_continue.play()

func _on_cast_spell(_spell: String):
	$sequence_success.play()

func _on_begin_spell():
	$sequence_begin.play()	
