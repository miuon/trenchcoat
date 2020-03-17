extends Node2D
class_name GridManager

signal register_mover(mover)

func register_mover(mover: GridMover) -> void:
	emit_signal("register_mover", mover)

func _ready() -> void:
	_on_ready()

func _on_ready() -> void:
	pass
