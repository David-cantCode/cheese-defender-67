extends Node2D


signal scene_changed(new_scene_path: String)

func _on_timer_timeout() -> void:
	emit_signal("scene_changed", "res://screens/title.tscn")
