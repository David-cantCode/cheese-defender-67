extends CharacterBody3D


const SPEED = 550.0
var has_hit
var dmg = 15

var animations = ["spin_y", "spin_x", "spin_z"]
@onready var ani = $AnimationPlayer

func _ready() -> void:
	var rn_ani = animations.pick_random()
	ani.play(rn_ani)


func _physics_process(delta: float) -> void:
	var velocity = transform.basis * Vector3(0, 0, -SPEED) * delta
	
	var collision = move_and_collide(velocity)
	
	if collision and !has_hit:
		var collider = collision.get_collider()
		if collider and collider.has_method("hit"):
			has_hit = true
			collider.hit(dmg, velocity)   
			self.queue_free()


func _on_life_timer_timeout() -> void:
	self.queue_free()
