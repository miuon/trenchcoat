extends TileMap
class_name Grid

var movers = {}

func _register_mover(mover: GridMover) -> void:
	movers[mover] = true
	mover.grid = self
	mover.position = map_to_world(world_to_map(mover.position))

func mover_at_cell(cell: Vector2) -> GridMover:
	for mover in movers.keys():
		if world_to_map(mover.position) == cell:
			return mover

func get_obstacle(mover: GridMover, direction: Vector2) -> GridMover:
	var start_cell := world_to_map(mover.position)
	var target_cell := start_cell + direction
	return mover_at_cell(target_cell)

func get_move_target(mover: GridMover, direction: Vector2) -> Vector2:
  var start_cell := world_to_map(mover.position)
  var target_cell := start_cell + direction
  return map_to_world(target_cell)

func delete_mover(mover: GridMover) -> void:
	movers.erase(mover)
	mover.queue_free()
