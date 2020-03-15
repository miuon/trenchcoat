extends TileMap

var movers = {}

func _register_mover(mover):
	movers[mover] = true
	mover.grid = self
	mover.position = map_to_world(world_to_map(mover.position))

func mover_at_cell(cell):
	for mover in movers.keys():
		if world_to_map(mover.position) == cell:
			return mover

func get_obstacle(mover, direction):
	var start_cell = world_to_map(mover.position)
	var target_cell = start_cell + direction
	return mover_at_cell(target_cell)

func get_move_target(mover, direction):
  var start_cell = world_to_map(mover.position)
  var target_cell = start_cell + direction
  return map_to_world(target_cell)

func delete_mover(mover):
	movers.erase(mover)
	mover.queue_free()
