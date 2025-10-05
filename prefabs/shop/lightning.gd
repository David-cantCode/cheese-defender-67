extends CharacterBody3D




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if is_on_floor():
		velocity.y = +5
		
		strike()
	move_and_slide()

func strike():
	pass
