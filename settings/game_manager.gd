extends Node3D



@onready var current_scene: Node = null

func _ready():
	# load title
	change_scene("res://screens/title.tscn")


func change_scene(scene_path: String):
	
	if current_scene:
		current_scene.queue_free() # Remove old scene

	var scene_res = load(scene_path)
	var scene = scene_res.instantiate()
	add_child(scene)
	current_scene = scene


	scene.scene_changed.connect(_on_scene_changed)
		

func _on_scene_changed(new_scene_path: String):
	change_scene(new_scene_path)
