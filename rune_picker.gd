extends Node2D
class_name Rune

var current_sequence = []
var spells = {
	"algiz" : {
		"gebo" : "heal"
	},
	"hagalaz" : {
		"algiz" : "shield"
	},
	"naudiz" : {
		"hagalaz" : {
			"gebo" : "fireball"
		}
	}
}

signal cast_spell(spell:String)
signal wrong_spell()

# Called when the node enters the scene tree for the first time.
func _ready():
	place_runes()

# Place the runes evenly spaced around a circle
func place_runes():
	var total_runes = get_child_count()
	var angle_increment = 2*PI / total_runes
	var radius = 100.0

	for i in range(total_runes):
		var rune = get_child(i)
		var x = radius * cos(angle_increment * i)
		var y = radius * sin(angle_increment * i)
		print(rune.name + " at " + str(x) + ", " + str(y))
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
	for rune in get_children():
		rune.unselect()

func _on_rune_selected(rune:String):
	current_sequence.append(rune)
	check_sequence()
