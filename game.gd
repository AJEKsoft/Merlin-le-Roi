extends Node2D

signal player_death
signal player_attack

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_foe()
	# Set up the values of the bars.
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.set_max_value(PlayerState.health_max)
	player_health_bar.new_value(PlayerState.health)
	PlayerState.health = PlayerState.health_max
	
	var player_mana_bar = find_child("player-mana-bar")
	player_mana_bar.set_max_value(PlayerState.mana_max)
	player_mana_bar.new_value(PlayerState.mana)
	PlayerState.mana = PlayerState.mana_max
	
	$game_canvas/SpellTable.radius = get_viewport_rect().size.y / 3
	$game_canvas/SpellTable.place_runes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	PlayerState.mana += PlayerState.mana_regen * delta
	PlayerState.mana = min(PlayerState.mana, PlayerState.mana_max)
	find_child("player-mana-bar").new_value(PlayerState.mana)
	pass
	
func spawn_foe():
	# To change the kind of monster we spawn, we change the scene that's loaded.
	var possible_monsters = LevelState.per_level_enemies[LevelState.current_level]
	var monster_scene = load(possible_monsters[randi() % possible_monsters.size()])
	var monster = monster_scene.instantiate()
	monster.health_progress = find_child("foe-health-bar")
	monster.death.connect(_on_foe_death)
	monster.attack.connect(_on_foe_attack)
	player_attack.connect(monster._on_attacked)
	monster.position = $Dungeon/DungeonCamera.position + $Dungeon/DungeonCamera.global_transform.basis.z * -1
	find_child("foe-name").text = monster.name
	$Dungeon.add_child(monster)

func _on_cast_spell(spell:String):
	$ui_canvas/ui/spellname.text = spell
	if PlayerState.mana < 10:
		find_child("spellname").text = "OUT OF MANA"
	else:
		find_child("player-mana-bar").reduce_value(10)
		PlayerState.mana = max(PlayerState.mana - 10, 0)
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
	player_health_bar.new_value(min(player_health_bar.value + 10, player_health_bar.max_value))

func _on_foe_attack(damage: int):
	var player_health_bar = find_child("player-health-bar")
	player_health_bar.reduce_value(damage)
	if player_health_bar.value == 0:
		emit_signal("player_death")

func _on_foe_death():
	get_tree().change_scene_to_file("res://victory_screen.tscn")

func _on_player_death():
	get_tree().change_scene_to_file("res://death_screen.tscn")
