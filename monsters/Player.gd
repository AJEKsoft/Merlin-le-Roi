extends Monster

class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

func _on_spell_table_cast_spell(spell:Spell):
	spell.transform = $spellStart.global_transform
	owner.add_child(spell)

func _process(delta):
	super._process(delta)
	if not (is_moving or is_rotating):
		if Input.is_action_pressed("dungeon_move_forward"):
			request_move.emit(get_forward_cell_position())
		if Input.is_action_pressed("dungeon_move_backward"):
			request_move.emit(get_backward_cell_position())
		if Input.is_action_pressed("dungeon_turn_left"):
			rotate_to(current_rotation + 90)
		if Input.is_action_pressed("dungeon_turn_right"):
			rotate_to(current_rotation - 90)
		if Input.is_action_just_pressed("dungeon_action"):
			action.emit()