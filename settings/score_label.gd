extends Node


@onready var score_label = $score_label

func _process(delta: float) -> void:
	score_label.text = "Waves passed: " + str(Global.waves_passed)
