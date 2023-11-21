extends Node2D

var mana = 100
var mana_regen_rate = 2

signal player_death
signal player_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_foe()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_mana_bar = find_child("player-mana-bar")
	if player_mana_bar.value < player_mana_bar.max_value:
		player_mana_bar.value = min(player_mana_bar.value + mana_regen_rate * delta, player_mana_bar.max_value)

func spawn_foe():
	# To change the kind of monster we spawn, we change the scene that's loaded.
	var monster_scene = load("res://monsters/goblin.tscn")
	var monster = monster_scene.instantiate()
	monster.health_progress = find_child("foe-health-bar")
	add_child(monster)
	monster.death.connect(_on_foe_death)
	monster.attack.connect(_on_foe_attack)
	player_attack.connect(monster._on_attacked)

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

func _on_wrong_spell():
	$sequence_fail.play()
	find_child("spellname").text = "WRONG SPELL"

func spell_fireball():
	emit_signal("player_attack", 10)

func spell_heal():
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.value = min(player_health_bar.value + 10, player_health_bar.max_value)

func _on_regen_timeout():
	var player_mana_bar = find_child("player-mana-bar")
	player_mana_bar.value = min(player_mana_bar.value + mana_regen_rate, player_mana_bar.max_value)

func _on_foe_attack(damage: int):
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.value = max(player_health_bar.value - damage, 0)
	if player_health_bar.value == 0:
		emit_signal("player_death")

func _on_foe_death():
	get_tree().change_scene_to_file("res://victory_screen.tscn")

func _on_player_death():
	get_tree().change_scene_to_file("res://death_screen.tscn")
