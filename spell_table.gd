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
signal cast_spell(spell:Spell)
signal wrong_spell

@export var rotation_speed : float = 1 # rotations per minute
var radius = 200.0

func _ready():
	pass

func _process(delta : float):
	place_runes()
	var angular_speed = rotation_speed * 2 * PI / 60 # radians per second
	$runes_circle.rotate(delta * angular_speed)
	for rune in $runes_circle.get_children():
		rune.rotate(-delta * angular_speed)
func _draw():
	# draw a circle behind the runes
	draw_arc($runes_circle.position, radius, 0, 2*PI, 64, Color(1,1,1,0.5), 2)

# Place the runes evenly spaced around a circle
func place_runes():
	var total_runes = 0
	for child in $runes_circle.get_children():
		if child is Rune:
			total_runes += 1
	var angle_increment = 2*PI / total_runes

	radius = min(get_viewport().size.x, get_viewport().size.y) / 2 - 50
	$runes_circle.position = Vector2i(radius + 50, radius + 50)
	var i = 0
	for child in $runes_circle.get_children():
		if child is Rune:
			var x = radius * cos(angle_increment * i)
			var y = radius * sin(angle_increment * i)
			child.position = Vector2(x, y)
			i += 1

func check_sequence():
	var current_spell = spells
	for rune in current_sequence:
		if current_spell.has(rune):
			current_spell = current_spell[rune]
		else:
			current_spell = null
			reset_sequence()
			wrong_spell.emit()
	if typeof(current_spell) == TYPE_STRING:
		reset_sequence()
		cast_spell.emit(load("res://spells/"+current_spell+".tscn").instantiate())
	elif typeof(current_spell) == TYPE_DICTIONARY:
		pass
	else:
		reset_sequence()
		wrong_spell.emit()

func reset_sequence():
	for rune in current_sequence:
		$runes_circle.get_node(rune).unselect()
	current_sequence = []

func _on_rune_selected(rune:String):
	if current_sequence.size() == 0:
		begin_spell.emit()
	else:
		continue_spell.emit()
	current_sequence.append(rune)
	check_sequence()

func _on_wrong_spell():
	$sequence_fail.play()

func _on_continue_spell():
	$sequence_continue.play()

func _on_cast_spell(_spell: Spell):
	$sequence_success.play()

func _on_begin_spell():
	$sequence_begin.play()	
