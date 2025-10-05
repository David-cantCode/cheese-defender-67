extends Node2D

signal scene_changed(new_scene_path: String)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("buy"):
		emit_signal("scene_changed", "res://world.tscn")
