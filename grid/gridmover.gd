extends Node2D

export var move_time = 0.5
export var bump_time = 0.3
export var pushable = false
var grid
var manager

var moving = false
var busy = false

func _ready():
	manager = get_parent()
	manager.register_mover(self)
	_on_ready()

func _on_ready():
	pass

func _physics_process(delta):
	_on_physics_process(delta)

func _on_physics_process(_delta):
	pass

func try_push(pusher):
	if not pushable:
		return false
	var direction = (self.position - pusher.position).normalized()
	return try_move(direction, true)
	
func try_move(direction, pushed=false):
	return move(grid.get_obstacle(self, direction),
			grid.get_move_target(self, direction),
			pushed)

func move(obstacle, target_position, _pushed=false):
	# TODO: clean up, share more code with subclasses
	if not obstacle:
		move_to(target_position)
		return true
	if obstacle.try_push(self):
		move_to(target_position)
		return true
	bump()
	return false

func move_to(target_position):
	moving = true
	busy = true

	var move_vector = target_position - position
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

func bump():
	busy = true
	$BumpTimer.start(bump_time)
	yield($BumpTimer, "timeout")
	busy = false

# various overridable checks
func is_baby():
	return false

func is_trenchcoat():
	return false
