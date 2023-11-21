extends Node2D

class_name Monster

# references to UI elements describing the monster
var health_progress = null 

@export var attributes : MonsterAttributes
@export var gfx : MonsterGFX
@export var sfx : MonsterSFX

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
	health = attributes.max_health
	mana = attributes.max_mana
	health_progress.max_value = attributes.max_health
	health_progress.value = health
	add_child(attack_timer)
	if sfx != null:
		if sfx.death_sound != null:
			death_sound_player.stream = attributes.death_sound
		add_child(death_sound_player)
		if sfx.hurt_sound != null:
			hurt_sound_player.stream = attributes.hurt_sound
		add_child(hurt_sound_player)
		if sfx.attack_sound != null:
			attack_sound_player.stream = attributes.attack_sound
		add_child(attack_sound_player)
	if gfx != null:
		if gfx.default_image != null:
			var sprite = Sprite2D.new()
			sprite.texture = attributes.default_image
			add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = min(health + attributes.health_regen_rate * delta, attributes.max_health)
	mana = min(mana + attributes.mana_regen_rate * delta, attributes.max_mana)
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
	emit_signal("attack", attributes.strength)
