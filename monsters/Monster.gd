extends Area3D

class_name Monster

# references to UI elements describing the monster
var health_progress = null 

@export var attributes : MonsterAttributes

signal attack(value: int)
signal death
signal health_changed(value: int)

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
	health_progress = find_child("health-bar")
	health_progress.set_max_value(attributes.max_health)
	health_progress.new_value(health)
	find_child("name").set_text(self.name)
	add_child(attack_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = min(health + attributes.health_regen_rate * delta, attributes.max_health)
	mana = min(mana + attributes.mana_regen_rate * delta, attributes.max_mana)
	health_progress.new_value(health)

func _on_attacked(damage : int):
	health -= damage
	health_progress.reduce_value(damage)
	if health <= 0:
		death_sound_player.play()
		emit_signal("death")
		queue_free()
	else:
		hurt_sound_player.play()

func _on_attack_timeout():
	attack_sound_player.play()
	emit_signal("attack", attributes.strength)


func _on_death():
	queue_free()
