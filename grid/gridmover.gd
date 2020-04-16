extends Node2D
class_name GridMover

export var move_time : float = 0.5
export var bump_time : float = 0.3
export var pushable : bool = false
var grid
var manager

var move_proposed := false
var moving := false
var busy := false

func _ready() -> void:
	manager = get_parent()
	manager.register_mover(self)
	_on_ready()

func _on_ready() -> void:
	pass

func _process(delta: float) -> void:
	_on_process(delta)

func _on_process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if move_proposed:
		evaluate_move()
	_on_physics_process(delta)

func _on_physics_process(_delta: float) -> void:
	pass

func try_move(direction: Vector2):
	return move(direction, false)

func try_push(direction: Vector2) -> bool:
	if not pushable:
		return false
	return move(direction, true)

func move(direction: Vector2, pushed:bool=false) -> bool:
	var target_position = grid.get_move_target(self, direction)
	$Area2D.position = target_position
	if bodies:
		bump()
		return false
	elif areas:
		# TODO: what if there's more than one
		if len(areas) > 1:
			position = orig_pos
			bump()
			return false
		var other: GridMover = areas[0].get_parent()
		var should_move = collide_with(other, direction, pushed)
		if should_move:
			execute_move(orig_pos, target_position)
		return should_move
	else:
		execute_move(orig_pos, target_position)
		return true

func collide_with(other: GridMover,
		direction: Vector2,
		pushed:bool=false) -> bool:
	return other.try_push(direction)
	
func execute_move(
		start_position: Vector2,
		target_position: Vector2) -> void:
	moving = true
	busy = true

	var move_vector: Vector2 = target_position - position
	position = target_position
	$Tween.interpolate_property(
		$Pivot,
		"position",
		-move_vector,
		Vector2.ZERO,
		move_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")

	moving = false
	busy = false

func bump() -> void:
	busy = true
	$BumpTimer.start(bump_time)
	yield($BumpTimer, "timeout")
	busy = false

# various overridable checks
func is_baby() -> bool:
	return false

func is_trenchcoat() -> bool:
	return false
