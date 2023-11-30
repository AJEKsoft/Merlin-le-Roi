extends Control 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_update_mana(maxv: int, current: int):
	find_child("player-mana-bar").new_value(current)
	find_child("player-mana-bar").set_max_value(maxv)

func _on_player_update_health(maxv: int, current: int):
	find_child("player-health-bar").new_value(current)
	find_child("player-health-bar").set_max_value(maxv)

func _on_player_damaged(damage: int):
	find_child("player-health-bar").reduce_value(damage)

func _on_player_lost_mana(value: int):
	find_child("player-mana-bar").reduce_value(value)
