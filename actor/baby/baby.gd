extends "res://actor/actor.gd"

func _process(_delta):
	var ani = get_node("Pivot/AnimatedSprite")
	if self.moving and not ani.playing:
		ani.play()
	if not self.moving and ani.playing:
		ani.stop()

func move(obstacle, target_position, pushed=false):
	if not obstacle:
		move_to(target_position)
		return true
	if obstacle.is_trenchcoat() and not pushed:
		if not obstacle.return_baby():
			return false
		self.give_focus_to(obstacle)
		grid.delete_mover(self)
		return true
	if obstacle.try_push(self):
		move_to(target_position)
		return true
	bump()
	return false

func is_baby():
	return true
