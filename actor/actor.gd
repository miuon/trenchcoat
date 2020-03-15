extends "res://grid/gridmover.gd"

export var focused = false

func _on_ready():
	# make sure onfocus stuff gets run
	self.set_focused(focused)

func _on_physics_process(delta):
	._on_physics_process(delta)
	var input_direction = get_input_direction()
	if input_direction:
		.try_move(input_direction)

func get_input_direction():
	if self.busy or not focused:
		return
	if Input.is_action_pressed("left"):
		return Vector2.LEFT
	if Input.is_action_pressed("right"):
		return Vector2.RIGHT
	if Input.is_action_pressed("up"):
		return Vector2.UP
	if Input.is_action_pressed("down"):
		return Vector2.DOWN

func give_focus_to(other):
	# TODO: this needs to transfer input cooldown
	self.set_focused(false)
	other.set_focused(true)

func set_focused(is_focused):
	self.focused = is_focused
	$Pivot/FocusHighlight.visible = is_focused
