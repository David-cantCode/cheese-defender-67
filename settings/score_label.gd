extends Node


@onready var score_label = $score_label

func _process(delta: float) -> void:
	score_label.text = "Score: " + str(Global.score)
