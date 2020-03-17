extends Node2D
class_name GridMover

export var move_time : float = 0.5
export var bump_time : float = 0.3
export var pushable : bool = false
var grid
var manager

var moving := false
var busy := false

func _ready() -> void:
	manager = get_parent()
	manager.register_mover(self)
	_on_ready()

func _on_ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_on_physics_process(delta)

func _on_physics_process(_delta: float) -> void:
	pass

func try_push(pusher: GridMover) -> bool:
	if not pushable:
		return false
	var direction = (self.position - pusher.position).normalized()
	return try_move(direction, true)
	
func try_move(direction: Vector2, pushed:bool=false) -> bool:
	return move(grid.get_obstacle(self, direction),
			grid.get_move_target(self, direction),
			pushed)

func move(obstacle: GridMover,
		target_position: Vector2,
		_pushed:bool=false) -> bool:
	# TODO: clean up, share more code with subclasses
	if not obstacle:
		move_to(target_position)
		return true
	if obstacle.try_push(self):
		move_to(target_position)
		return true
	bump()
	return false

func move_to(target_position: Vector2) -> void:
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
