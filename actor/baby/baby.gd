extends Actor
class_name Baby

func _process(_delta: float) -> void:
	var ani: AnimatedSprite = get_node("Pivot/AnimatedSprite")
	if self.moving and not ani.playing:
		ani.play()
	if not self.moving and ani.playing:
		ani.stop()

func collide_with(other: GridMover,
		direction: Vector2,
		pushed:bool=false) -> bool:
	if other.is_trenchcoat() and not pushed:
		if not other.return_baby():
			return false
		self.give_focus_to(other)
		grid.delete_mover(self)
		return true
	else:
		return other.try_push(direction)

func is_baby() -> bool:
	return true
