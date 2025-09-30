extends Area3D

var dead


func hit(dmg):
	Global.chese_health -= dmg
	$SubViewport/healthbar3D.value = Global.chese_health
	
	if Global.chese_health <= 0:
		Global.game_over = false
