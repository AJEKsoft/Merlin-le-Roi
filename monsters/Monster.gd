extends Node2D

class_name Monster

# references to UI elements describing the monster
var health_progress = null 

signal attack(value: int)
signal death
var health
var mana
@export var attack_timer : Timer = Timer.new()
@export var settings : MonsterSettings

func _ready():
	attack_timer.timeout.connect(_on_attack_timeout)
	attack_timer.autostart = true
	health = settings.max_health
	mana = settings.max_mana
	health_progress.max_value = settings.max_health
	health_progress.value = health
	add_child(attack_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = min(health + settings.health_regen_rate * delta, settings.max_health)
	mana = min(mana + settings.mana_regen_rate * delta, settings.max_mana)
	health_progress.value = health

func _on_attacked(damage : int):
	health -= damage
	health_progress.value = health
	if health <= 0:
		if settings.death_sound != null:
			settings.death_sound.play()
		emit_signal("death")
		queue_free()
	else:
		if settings.hurt_sound != null:
			settings.hurt_sound.play()

func _on_attack_timeout():
	if settings.attack_sound != null:
		settings.attack_sound.play()
	emit_signal("attack", settings.strength)
