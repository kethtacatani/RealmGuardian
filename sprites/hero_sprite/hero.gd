extends CharacterBody2D



var SPEED = 380.0
var JUMP_VELOCITY = -500.0
var prevX=0
var prevY=0
var has_double_jump=false
var animation_locked= false
var direction
var was_in_air= false
var facing_right=true
var new_game=false
var health_bar


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")


func _ready():	
	anim.play('idle')
	
	

func _physics_process(delta):
	# Add the gravity.
#	print("x: ",prevX)
#	print("y: ",prevY)
	
	if new_game && is_on_floor():
		new_game=false
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"start")
			
		
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air=true
		
	else:
		has_double_jump=false
		if was_in_air:
			land()	
			was_in_air=false;	
		
	if global.is_in_dialogue:
		if is_on_floor():	
			anim.play("idle")
			animation_locked=false
			print("id")
			return
	else:
			print("nid")
			

	# Handle Jump.
	
	if Input.is_action_just_pressed("ui_accept"):
		#double jump
		if is_on_floor():
			jump()
		elif not has_double_jump:
			double_jump()
			
			
	direction = Input.get_axis("ui_left", "ui_right")		
	#animation for jump
	if not is_on_floor():
		jump_anim()
	prevX= position.x
	prevY=position.y

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	

	move_and_slide()
	update_facing_sprite()
	update_animation()

	
func update_animation():
	if not animation_locked:
		if direction:
			velocity.x = direction * SPEED
			if is_on_floor():
				anim.play('run')	
#				print(direction)	
		else:
			if is_on_floor():
				if facing_right:
					anim.play('idle')
					
				else:
					anim.play('idle_left')
					
				velocity.x = move_toward(velocity.x, 0, SPEED)
	#		else:
	#			velocity.x = move_toward(velocity.x, 0, SPEED)	
		
func update_facing_sprite():
	if direction:
		if direction < 0: # Check if moving left
			anim.flip_h = true # Flip the character horizontally
			facing_right=false
		else:
			anim.flip_h = false # Otherwise, don't flip
			facing_right=true
			
func jump_anim():
	if not animation_locked:
		if position.y<prevY:
			anim.play("jump_up_loop")
		else:
			anim.play("jump_down_loop")
			velocity.x = direction * SPEED*0.5
			animation_locked=true
	
	
func jump():
	anim.play("jump_up")
	velocity.y = JUMP_VELOCITY
	animation_locked=true
func double_jump():
	anim.play("double_jump")
	velocity.y = JUMP_VELOCITY*0.6
	has_double_jump=true
	animation_locked=true
	
func land():
	anim.play("jump_down")
	velocity.x = move_toward(velocity.x, 0, SPEED)
	animation_locked=true
	
	
	
	

func _on_animated_sprite_2d_animation_finished():
	if(anim.animation=="jump_down"):
		animation_locked=false
	if(anim.animation=="jump_up"):
		animation_locked=false
#		print("finished")
	if(anim.animation=="double_jump"):
		animation_locked=false
		



	
		
