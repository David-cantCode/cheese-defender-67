extends Node2D


signal scene_changed(new_scene_path: String)


func _ready() -> void:
	print("title")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Global.money = 0
	Global.chese_health = 100 
	Global.level = 1
	Global.game_over = false
	$AnimationPlayer.play("spin")


func _process(delta: float) -> void:
	if !$music.playing:
		$music.play()


func _on_github_button_down() -> void:
	OS.shell_open("https://github.com/David-cantCode")


func _on_itch_button_down() -> void:
	OS.shell_open("https://david-cantcode.itch.io/")


func _on_start_button_down() -> void:
	emit_signal("scene_changed", "res://screens/goal.tscn")
