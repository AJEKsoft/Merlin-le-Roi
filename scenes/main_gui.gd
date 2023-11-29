extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
