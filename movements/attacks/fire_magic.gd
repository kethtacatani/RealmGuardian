extends CharacterBody2D


const SPEED = 1000.0
var direction=1

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")
func _ready():	
	anim.play("fire")

func _physics_process(delta):
	# Add the gravity.
	velocity.x = direction * SPEED

	# Handle Jump.

	move_and_slide()
