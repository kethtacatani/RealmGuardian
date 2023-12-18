extends CharacterBody2D


var speed = 0
const JUMP_VELOCITY = -400.0
var fire_position
var direction= 1 if global.player_direction==1 else -1
var firing=false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")

var collision
var range2

func _ready():	
	fire_position=global_position
	collision= $CollisionShape2D
	range2= $range2
	remove_child(collision)
	remove_child(range2)
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("fire_magic") and global.health!=0:
		$FireDelay.start()
	velocity.x = direction * speed
	
	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func attack_fire_magic():
	direction= 1 if global.player_direction==1 else -1
	firing = true
	if direction==1:
		global_position.x = global.player_pos-30
		anim.flip_h=false
	elif direction== -1:
		global_position.x = global.player_pos-230
		anim.flip_h=true
	global_position.y = global.player_pos_y+20
	anim.play("fire_magic")
	speed = 1000
	add_child(collision)
	add_child(range2)
	$FireOut.start()
	
	


func _on_timer_timeout():
	speed=0
	anim.play("fire_hit")


func _on_area_2d_area_entered(area):
	if area.name=="hit_mark":
		$Timer.start()
		
		
		


func _on_animated_sprite_2d_animation_finished():
	if anim.animation=="fire_hit":
		remove_child(collision)
		remove_child(range2)
	if anim.animation=="fire_out":
		remove_child(collision)
		remove_child(range2)
		


func _on_fire_delay_timeout():
	attack_fire_magic()


func _on_fire_out_timeout():
	anim.play("fire_out")
	
