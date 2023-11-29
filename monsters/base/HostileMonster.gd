extends Monster

class_name HostileMonster


func _process(delta):
	var player = get_tree().root.find_child("Player")
	if player == null:
		return

	var player_pos = player.global_transform.origin
	var monster_pos = global_transform.origin
	look_at_from_position(monster_pos, player_pos, Vector3.UP)

func _on_attack_timeout():
	print("Attack not implemented for ", typeof(self))
