extends CharacterBody3D


var speed = 2
var max_health = 800 
var health
var dead 
var money_gain = randi_range(5,15)
var can_attack = true
@onready var healthbar = $SubViewport/healthbar3D
var last_knockback: Vector3 = Vector3.ZERO
var dmg = 30
@onready var target = get_node("../../TheChese")


signal boss_dead

func _ready() -> void:
	healthbar.max_value = max_health
	health = max_health
	
	healthbar.value = health
	$score_label.visible = false
	

func on_death():
		$death_timer.start(0.5)
		Global.money += money_gain
		Global.waves_passed += 1
		$score_label.visible = true; $score_label.text = "+ $" + str(money_gain)
		dead = true
		$"score_label/score-ani".play("dead")
		$SubViewport/healthbar3D.visible = false
		
		velocity.y += 2
		velocity += last_knockback
		

func _physics_process(delta: float) -> void:
	if health <= 0 and !dead:	
		on_death()

	if not is_on_floor():
		velocity.y -= 9.81 * delta
		
	
	move_to_target(delta)
		
	move_and_slide()
	if position.y <= -10: health = 0


func hit(dmg, knockback):
	if dead: return
	health -= dmg
	
	healthbar.value = health
	
	$sprite/AnimationPlayer.play("hit")
	
	position += knockback
	last_knockback = knockback
	move_and_slide()


func _on_death_timer_timeout() -> void:
	emit_signal("boss_dead")
	self.queue_free()


func move_to_target(delta):
	if dead: return
	
	if target:
		var to_target = target.global_position - global_position
		var distance = to_target.length()
		
		if distance > 1.0: 
			var direction = to_target.normalized()
			global_translate(direction * speed * delta)
			if !$sprite/AnimationPlayer.is_playing(): $sprite/AnimationPlayer.play("moving")
			
		if distance <= 1.0:
			if target.has_method("hit"):
				if can_attack:
					can_attack = false
					target.hit(dmg)
					$atk_timer.start()
	


func _on_atk_timer_timeout() -> void:
	can_attack = true
