extends Node2D

signal register_mover(mover)

func register_mover(mover):
	emit_signal("register_mover", mover)

func _ready():
	_on_ready()

func _on_ready():
	pass
