extends GridManager
class_name ActorManager

func register_mover(mover: GridMover) -> void:
	.register_mover(mover)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("cycle"):
		cycle_focus(get_children())

func cycle_focus(actors: Array):
	var current_focused_element: Actor
	var new_focused_element: Actor
	for i in range(actors.size()):
		if actors[i].focused:
			current_focused_element = actors[i]
			new_focused_element = actors[(i + 1) % actors.size()]
			break
	if current_focused_element:
		current_focused_element.set_focused(false)
		new_focused_element.set_focused(true)
	else:
		# recover focus if we lost it somehow
		actors[0].set_focused(true)
