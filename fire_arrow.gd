extends CharacterBody2D


var speed = 0
const JUMP_VELOCITY = -400.0
var fire_position
var direction= 1 if global.player_direction==1 else -1
var firing=false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

@onready var anim= get_node("range1/AnimatedSprite2D")

var range1

func _ready():	
	fire_position=global_position
	range1= $range1
	remove_child(range1)
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("fire_arrow") and global.player_health!=0 and not global.attacking and global.can_range1:
		$FireDelay.start()
		direction= 1 if global.player_direction==1 else -1
	velocity.x = direction * speed
	
	
	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func attack_fire_arrow():
	global.attacking=false
	$AudioStreamPlayer2D.play()
	firing = true
	if direction==1:
		global_position.x = global.player_pos+120
		anim.flip_h=false
	elif direction== -1:
		global_position.x = global.player_pos-40
		anim.flip_h=true
	global_position.y = global.player_pos_y+40
	anim.play("fire_arrow")
	speed = 1000
	add_child(range1)
	$FireOut.start()
	
	


func _on_timer_timeout():
	speed=0
	anim.play("fire_hit")


func _on_area_2d_area_entered(area):
	if area.name=="hit_mark":
		$Timer.start()
		
		
		


func _on_animated_sprite_2d_animation_finished():
	if anim.animation=="fire_hit":
		remove_child(range1)
		


func _on_fire_delay_timeout():
	attack_fire_arrow()


func _on_fire_out_timeout():
	anim.play("fire_hit")
	
