extends Node2D

var mana = 100
var mana_regen_rate = 2

signal foe_death
signal player_death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_mana_bar = find_child("player-mana-bar")
	if player_mana_bar.value < player_mana_bar.max_value:
		player_mana_bar.value = min(player_mana_bar.value + mana_regen_rate * delta, player_mana_bar.max_value)
	check_death()

func check_death():
	var player_health_bar = find_child("player-health-bar")
	if player_health_bar.value <= 0:
		emit_signal("player_death")
	var foe_health_bar = find_child("foe-health-bar")
	if foe_health_bar.value <= 0:
		emit_signal("foe_death")

func _on_begin_spell():
	$sequence_begin.play()
	
func _on_continue_spell():
	$sequence_continue.play()

func _on_cast_spell(spell:String):
	$sequence_success.play()
	$ui_canvas/ui/spellname.text = spell
	find_child("player-mana-bar").value -= 10
	if spell == "fireball":
		spell_fireball()
	elif spell == "heal":
		spell_heal()
	pass # Replace with function body.

func _on_wrong_spell():
	$sequence_fail.play()
	find_child("spellname").text = "WRONG SPELL"

func spell_fireball():
	var foe_health_bar = find_child("foe-health-bar")
	foe_health_bar.value = max(foe_health_bar.value - 20, 0)

func spell_heal():
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.value = min(player_health_bar.value + 10, player_health_bar.max_value)

func goblin_attack():
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.value = max(player_health_bar.value - 10, 0)

func _on_regen_timeout():
	var player_mana_bar = find_child("player-mana-bar")
	player_mana_bar.value = min(player_mana_bar.value + mana_regen_rate, player_mana_bar.max_value)

func _on_foe_timeout():
	goblin_attack()

func _on_foe_death():
	pass # Replace with function body.


func _on_player_death():
	pass # Replace with function body.
