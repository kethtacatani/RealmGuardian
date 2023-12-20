extends CharacterBody2D

var speed = global.getRandomValue(400,500)
var collision
var bird_fire
var fired=false
var fire_position
var hit
var parent
var direction = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var anim= get_node("bird_fire/AnimatedSprite2D")
func _ready():
	collision= $CollisionShape2D
	bird_fire= $bird_fire
	hit=$Hit
	parent= get_parent()
	top_level
	

func _physics_process(delta):
	if not fired:
#		global_position.x =parent.global_position.x
#		global_position.y =parent.global_position.y
		fired=true


	move_and_slide()





func _on_bird_fire_body_entered(body):
	if body.name=="hero" or body.name=="StaticBody2D":
		anim.play("hit")
		global.player_hurt(parent.damage)
		
		


func _on_hit_timeout():
		pass
