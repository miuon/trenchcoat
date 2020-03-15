extends Label

export var normal_text = "wasd to move\nspace to disembark\ntab to cycle characters"
export var placing_text = "wasd to place agent"

func _ready():
	text = normal_text

func _placing_baby():
	text = placing_text

func _stopped_placing_baby():
	text = normal_text
