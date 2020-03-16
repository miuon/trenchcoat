extends "res://actor/actor.gd"

signal placing_baby
signal stopped_placing_baby

export var max_baby_count = 3
export var current_baby_count = 3
export var min_baby_count = 1
export var baby_scene = preload("res://actor/baby/baby.tscn")

var placing = false

func _on_ready():
	._on_ready()
	update_sprite_for_count()

func _on_physics_process(delta):
	._on_physics_process(delta)
	if not focused:
		return
	if Input.is_action_just_released("primary"):
		if not placing and not busy:
			maybe_start_placing()
	if placing:
		if Input.is_action_just_released("cancel"):
			cancel_placing()
		if Input.is_action_just_released("up"):
			place_baby(Vector2.UP)
		if Input.is_action_just_released("down"):
			place_baby(Vector2.DOWN)
		if Input.is_action_just_released("left"):
			place_baby(Vector2.LEFT)
		if Input.is_action_just_released("right"):
			place_baby(Vector2.RIGHT)

func _process(_delta):
	if not focused and placing:
		cancel_placing()

	var ani = get_node("Pivot/AnimatedSprite")
	if self.moving and not ani.playing:
		ani.play()
	if not self.moving and ani.playing:
		ani.stop()

func move(obstacle, target_position, _pushed=false):
	if not obstacle:
		move_to(target_position)
		return true
	if obstacle.try_push(self):
		move_to(target_position)
		return true
	bump()
	return false

func maybe_start_placing():
	if not can_emit_baby():
		return
	placing = true
	busy = true
	emit_signal("placing_baby")
	$Pivot/PlacingHighlight.visible = true

func cancel_placing():
	$Pivot/PlacingHighlight.visible = false
	emit_signal("stopped_placing_baby")
	placing = false
	busy = false

func place_baby(direction):
	$Pivot/PlacingHighlight.visible = false
	emit_signal("stopped_placing_baby")
	placing = false
	busy = false
	emit_baby(direction)

func can_emit_baby():
	return current_baby_count > min_baby_count

func emit_baby(direction):
	var target_position = grid.get_move_target(self, direction)
	var new_baby = baby_scene.instance()
	# TODO: make sure the spot is clear
	manager.add_child(new_baby)
	new_baby.position = target_position
	current_baby_count -= 1
	update_sprite_for_count()
	give_focus_to(new_baby)

func return_baby():
	if current_baby_count >= max_baby_count:
		return false
	current_baby_count += 1
	update_sprite_for_count()
	return true

func update_sprite_for_count():
	var sprite_name
	match current_baby_count:
		1:
			sprite_name = "one"
		2:
			sprite_name = "one"
		3:
			sprite_name = "two"
		_:
			sprite_name = "one"
	$Pivot/AnimatedSprite.animation = sprite_name

func is_trenchcoat():
	return true
