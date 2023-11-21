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
			"saggitarius" : "fireball"
		}
	}
}

signal begin_spell
signal continue_spell
signal cast_spell(spell:String)
signal wrong_spell

# Called when the node enters the scene tree for the first time.
func _ready():
	place_runes()

# Place the runes evenly spaced around a circle
func place_runes():
	var total_runes = $runes.get_child_count()
	var angle_increment = 2*PI / total_runes
	var radius = 200.0

	for i in range(total_runes):
		var rune = $runes.get_child(i)
		var x = radius * cos(angle_increment * i)
		var y = radius * sin(angle_increment * i)
		rune.position = Vector2(x, y) + get_viewport_rect().size/2

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
	for rune in $runes.get_children():
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
