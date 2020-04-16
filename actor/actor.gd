extends GridMover
class_name Actor

export var focused: bool = false

func _on_ready() -> void:
	# make sure onfocus stuff gets run
	self.set_focused(focused)

func _on_process(delta: float) -> void:
	._on_physics_process(delta)
	var input_direction: Vector2 = get_input_direction()
	if input_direction:
		.try_move(input_direction)

func get_input_direction() -> Vector2:
	if self.busy or not focused:
		return Vector2.ZERO
	if Input.is_action_pressed("left"):
		return Vector2.LEFT
	if Input.is_action_pressed("right"):
		return Vector2.RIGHT
	if Input.is_action_pressed("up"):
		return Vector2.UP
	if Input.is_action_pressed("down"):
		return Vector2.DOWN
	return Vector2.ZERO

func give_focus_to(other: Actor) -> void:
	# TODO: this needs to transfer input cooldown
	self.set_focused(false)
	other.set_focused(true)

func set_focused(is_focused: bool):
	self.focused = is_focused
	$Pivot/FocusHighlight.visible = is_focused
