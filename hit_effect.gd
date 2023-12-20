extends CharacterBody2D

var health=global.player_health

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var anim= get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Add the gravity.

	if health>global.player_health:
		anim.play("hit")
		health=global.player_health
		$Timer.start()		
	


func _on_timer_timeout():
	if global.player_health!=0:	
		if global.player_health+global.player_regen>global.player_max_health:
			global.player_health= global.player_max_health
		elif global.player_health<global.player_max_health:
			global.player_health+=global.player_regen
		
