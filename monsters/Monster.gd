extends Node2D

class_name Monster

# references to UI elements describing the monster
var health_progress = null 

@export var settings : MonsterSettings
signal attack(value: int)
signal death
var health
var mana
var attack_timer : Timer = Timer.new()
var death_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()
var hurt_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()
var attack_sound_player : AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	attack_timer.timeout.connect(_on_attack_timeout)
	attack_timer.autostart = true
	health = settings.max_health
	mana = settings.max_mana
	health_progress.max_value = settings.max_health
	health_progress.value = health
	add_child(attack_timer)
	if settings.death_sound != null:
		death_sound_player.stream = settings.death_sound
	add_child(death_sound_player)
	if settings.hurt_sound != null:
		hurt_sound_player.stream = settings.hurt_sound
	add_child(hurt_sound_player)
	if settings.attack_sound != null:
		attack_sound_player.stream = settings.attack_sound
	add_child(attack_sound_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = min(health + settings.health_regen_rate * delta, settings.max_health)
	mana = min(mana + settings.mana_regen_rate * delta, settings.max_mana)
	health_progress.value = health

func _on_attacked(damage : int):
	health -= damage
	health_progress.value = health
	if health <= 0:
		death_sound_player.play()
		emit_signal("death")
		queue_free()
	else:
		hurt_sound_player.play()

func _on_attack_timeout():
	attack_sound_player.play()
	emit_signal("attack", settings.strength)
