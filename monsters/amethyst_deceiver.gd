extends HostileMonster


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_attack_timeout():
	var slashAttack = load("res://monsters/attacks/SlashAttack.tscn").instantiate()
	slashAttack.position = $spellStart.transform.origin
	add_child(slashAttack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
