extends Node2D

var mana = 100
var mana_regen_rate = 2

signal player_death
signal player_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_foe()
	$game_canvas/SpellTable.radius = get_viewport_rect().size.y / 3
	$game_canvas/SpellTable.place_runes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_mana_bar = find_child("player-mana-bar")
	if player_mana_bar.value < player_mana_bar.max_value:
		player_mana_bar.value = min(player_mana_bar.value + mana_regen_rate * delta, player_mana_bar.max_value)

func spawn_foe():
	# To change the kind of monster we spawn, we change the scene that's loaded.
	var possible_monsters = LevelState.per_level_enemies[LevelState.current_level]
	var monster_scene = load(possible_monsters[randi() % possible_monsters.size()])
	var monster = monster_scene.instantiate()
	monster.health_progress = find_child("foe-health-bar")
	monster.death.connect(_on_foe_death)
	monster.attack.connect(_on_foe_attack)
	player_attack.connect(monster._on_attacked)
	monster.position = get_viewport_rect().size / 2
	find_child("foe-name").text = monster.name
	$game_canvas.add_child(monster)

func _on_cast_spell(spell:String):
	$ui_canvas/ui/spellname.text = spell
	find_child("player-mana-bar").value -= 10
	if spell == "fireball":
		spell_fireball()
	elif spell == "heal":
		spell_heal()

func _on_wrong_spell():
	find_child("spellname").text = "WRONG SPELL"

func spell_fireball():
	emit_signal("player_attack", 10)

func spell_heal():
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.value = min(player_health_bar.value + 20, player_health_bar.max_value)

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
