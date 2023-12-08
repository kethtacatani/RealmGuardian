extends CharacterBody2D


const SPEED = 0.0
const JUMP_VELOCITY = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0
@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")
func _ready():	
	anim.play('default')


func _physics_process(delta):
	# Add the gravity.
		
	if not is_on_floor():
		velocity.y += gravity * delta


	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name=='hero':
		self.queue_free()
