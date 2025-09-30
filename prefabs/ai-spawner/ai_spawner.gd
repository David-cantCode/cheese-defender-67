extends Node3D


@export var spawn_points: Array[NodePath] = [] # Add spawn markers in the scene

var mice_basic = load("res://prefabs/ai/basic-mouse.tscn")
var mice_footballer = load("res://prefabs/ai/footballmouse.tscn")
var mice_king = load("res://prefabs/ai/boses/mouse-king.tscn")

@onready var spawn_timer = $spawn_timer


var mice_spawned = 0
var time_between_spawns

var boss_fights = []

func _ready() -> void:
	level_one()
	boss_fights = [level_one_boss]

func level_one():
	#only spawn 10 normal mice
	time_between_spawns = 1.5
	mice_spawned = 0
	Global.mice_left = 10
	spawn_timer.start(time_between_spawns)

func level_one_boss():
	Global.boss_fight_txt = true
	var point = get_node(spawn_points.pick_random())
	var enemy = mice_king.instantiate()
	enemy.global_position = point.global_position
	add_child(enemy)


func level_two():
	pass




func _on_spawn_timer_timeout() -> void:
	if Global.game_over:
		spawn_timer.stop()
		return
		
	if mice_spawned >= Global.mice_left:
		boss_fights[Global.level -1 ].call()
		spawn_timer.stop()
		#start the boss fight
		return

	if spawn_points.size() > 0:
		var point = get_node(spawn_points.pick_random())
		var enemy = mice_basic.instantiate()
		enemy.global_position = point.global_position
		add_child(enemy)
	
	mice_spawned += 1
