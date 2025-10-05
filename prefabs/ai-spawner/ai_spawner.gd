extends Node3D

@export var spawn_points: Array[NodePath] = [] # Add spawn markers in the scene

var mice_basic = load("res://prefabs/ai/basic-mouse.tscn")
var mice_footballer = load("res://prefabs/ai/footballmouse.tscn")
var mice_king = load("res://prefabs/ai/boses/mouse-king.tscn")
var mecha_mice = load("res://prefabs/ai/boses/mecha-mouse.tscn")

@onready var spawn_timer = $spawn_timer

var mice_spawned = 0
var time_between_spawns
var spawn_queue = []
var speed_multiplier = 1.0
var health_multiplyer  = 1.0

signal boss_dead

func _ready() -> void:
	Global.level = 1
	start_level(Global.level)

#*******************
#********LEVELS
#***********************
func start_level(level: int) -> void:
	spawn_queue.clear()
	mice_spawned = 0
	
	# Scale difficulty over time
	speed_multiplier = 1.0 + (level - 1) * 0.4 
	health_multiplyer = 1.0 + (level - 1) * 0.4  
	time_between_spawns = max(0.5, 3.0 - (level * 0.3))  # faster spawns
	
	# Pattern cycles between 3 types
	match (level - 1) % 3:
		0:
			# Level One style
			for i in range(10 + level): # slightly more each loop
				spawn_queue.append(mice_basic)
		1:
			# Level Two style
			for i in range(5 + level):
				spawn_queue.append(mice_basic)
			spawn_queue.append(mice_footballer)
			spawn_queue.append(mice_footballer)
		2:
			# Level Three style
			for i in range(5 + int(level/2)):
				spawn_queue.append(mice_footballer)
				spawn_queue.append(mice_basic)
			spawn_queue.append(mice_footballer)
			spawn_queue.append(mice_footballer)
	
	Global.mice_left = spawn_queue.size()
	spawn_timer.start(time_between_spawns)

# -------------------------
# BOSSES
# -------------------------
func spawn_boss(level: int) -> void:
	var point = get_node(spawn_points.pick_random())
	
	if (level % 2) == 1:
		# Odd levels → King
		var boss = mice_king.instantiate()
		boss.global_position = point.global_position
		add_child(boss)
		boss.boss_dead.connect(_on_boss_dead)
	else:
		# Even levels → Mecha
		var boss = mecha_mice.instantiate()
		boss.global_position = point.global_position
		add_child(boss)
		boss.boss_dead.connect(_on_boss_dead)
		
		# Extra minion
		point = get_node(spawn_points.pick_random())
		var footballer = mice_footballer.instantiate()
		footballer.global_position = point.global_position
		add_child(footballer)

# -------------------------
# TIMER LOOP
# -------------------------
func _on_spawn_timer_timeout() -> void:
	if Global.game_over:
		spawn_timer.stop()
		return
	
	if mice_spawned >= Global.mice_left:
		spawn_timer.stop()
		spawn_boss(Global.level)
		return
	
	if spawn_points.size() > 0:
		var point = get_node(spawn_points.pick_random())
		var enemy_scene = spawn_queue[mice_spawned]
		var enemy = enemy_scene.instantiate()
		enemy.global_position = point.global_position
		add_child(enemy)
		enemy.speed *= speed_multiplier
		enemy.max_health *=  health_multiplyer
		enemy.health = enemy.max_health
		enemy.healthbar.max_value = enemy.max_health
		enemy.healthbar.value = enemy.health
	mice_spawned += 1

# -------------------------
# BOSS DEATH
# -------------------------
func _on_boss_dead() -> void:
	Global.level += 1
	start_level(Global.level)
