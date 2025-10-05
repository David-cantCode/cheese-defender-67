extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.004


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var ani = $AnimationPlayer
@onready var gun_barrel = $"Head/Gun_pos/gun tip"
@onready var pointer = $Head/Camera3D/pointer

var bullet = load("res://prefabs/cat/cat.tscn")
var instance


var guns = []
var gun_dmg = [20, 40, 70, 100]
var active_gun = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	guns = [
		$Head/Gun_pos/jolt,
		$Head/Gun_pos/pistol,
		$Head/Gun_pos/ak,
		$Head/Gun_pos/bazoka
	]


func shoot():
	if !ani.is_playing():
		ani.play("shoot")
		instance = bullet.instantiate()
		instance.position = gun_barrel.position
		instance.transform = gun_barrel.global_transform
		instance.dmg = gun_dmg[active_gun]
		get_parent().add_child(instance)

func _unhandled_input(event):
	if event is InputEventMouseMotion:

		rotate_y(-event.relative.x * sensitivity)
		head.rotate_x(-event.relative.y * sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	gun_control()
	
	store_check()
	
func gun_control():
	for gun in guns:
		gun.visible = false
	guns[active_gun].visible = true
	
	
	
func store_check():
	#obj: check if pointer ray is pointing to a gun, if press e buy that gun
	$"Head/Camera3D/e-to-buy".visible = false
	
	if pointer.is_colliding():
		$"Head/Camera3D/e-to-buy".visible = true
		#show label (Press e to buy)
			
		var collider = pointer.get_collider()
			#sorry for all the ifs 
			
		if Input.is_action_just_pressed("buy"):
			
			
			if collider.is_in_group("pistol"):
				if Global.money >= 67:
					Global.money -= 67
					active_gun = 1
			if collider.is_in_group("ak"):
				if Global.money >= Global.ak_price:
					Global.money -= Global.ak_price
					active_gun = 2
			if collider.is_in_group("bazoka"):
				if Global.money >= Global.bazooka_price:
					Global.money -= Global.bazooka_price
					active_gun = 3
			if collider.is_in_group("health"):
				if Global.money >= 100:
					Global.money -= 100
					Global.chese_health += 50
					
