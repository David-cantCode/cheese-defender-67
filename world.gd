extends Node3D

signal scene_changed(new_scene_path: String)

func _process(delta: float) -> void:
	if Global.game_over:
		emit_signal("scene_changed", "res://screens/game_over.tscn")
