extends Label
class_name DemoLabel

export var normal_text := "wasd to move\nspace to disembark\ntab to cycle characters"
export var placing_text := "wasd to place agent"

func _ready() -> void:
	text = normal_text

func _placing_baby() -> void:
	text = placing_text

func _stopped_placing_baby() -> void:
	text = normal_text
