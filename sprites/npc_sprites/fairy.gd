extends CharacterBody2D


const SPEED = 0.0
const JUMP_VELOCITY = 0.0
var collision

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity =0

@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")
func _ready():	
	anim.play('idle')
	
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta





func _on_area_2d_body_entered(body):
#	print("en ",body.name)
	if not global.fairy_talked:
		if body.name=='hero':
			global.is_in_dialogue=true
			anim.flip_h=true
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"fairy")


func _on_area_2d_body_exited(body):
	if body.name=='hero':
		pass
			
	



		
		
