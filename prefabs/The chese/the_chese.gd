extends Area3D

var dead


func hit(dmg):
	Global.chese_health -= dmg
	
	if Global.chese_health <= 0:
		Global.game_over = true




func _process(delta: float) -> void:
	if Global.chese_health >= 100: Global.chese_health = 100
	$SubViewport/healthbar3D.value = Global.chese_health
