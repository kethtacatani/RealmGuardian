extends CharacterBody2D



var SPEED = 450.0 #380
var JUMP_VELOCITY = -700.0
var prevX=0
var prevY=0
var has_double_jump=false
var animation_locked= false
var attack_facing_lock=false
var direction=1
var was_in_air= false
var facing_right=true
var new_game=false
var health_bar
var dead= false
var default_gravity=1200


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = default_gravity
var melee_area

@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")

func _ready():	
	anim.play('idle')
	global.player_direction=direction
	melee_area=$melee_attack1
	remove_child(melee_area)
	
	

func _physics_process(delta):
	# Add the gravity.
#	print("x: ",prevX)
#	print("y: ",prevY)
	if_dead()
	global.player_pos= global_position.x
	global.player_pos_y= global_position.y

	
	if new_game && is_on_floor():
		new_game=false
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"start")
			
		
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air=true
		
	else:
		gravity= default_gravity
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
			pass
			
	
	# Handle Jump.
	
	if Input.is_action_just_pressed("ui_accept") and not dead:
		#double jump
		if is_on_floor() and not global.attacking:
			jump()
		elif not has_double_jump and not is_on_floor():
			double_jump()
	#handle melee_attack1
	if Input.is_action_just_pressed("melee_attack1") and not dead and global.can_melee1:
		$MeleeTimer.wait_time=global.melee1_cooldown
		global.can_melee1=false
		$MeleeTimer.start()
		attack_melee1()
	if Input.is_action_just_pressed("fire_arrow") and not dead and global.can_range1:
		$Range1Timer.wait_time=global.range1_cooldown
		global.can_range1=false
		$Range1Timer.start()
		attack_range1()
		
	if Input.is_action_just_pressed("fire_magic") and not dead and global.can_range2:
		$Range2Timer.wait_time=global.range2_cooldown
		global.can_range2=false
		$Range2Timer.start()
		attack_range2()
		print("can")
	
			
	direction = Input.get_axis("ui_left", "ui_right")
	
	if not is_on_floor():
		jump_anim()
	prevX= position.x
	prevY=position.y
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	

	move_and_slide()
	update_facing_sprite()
	update_animation()
	
	
#attacks
func attack_melee1():
	if not global.attacking:
		add_child(melee_area)
		anim.play("attack_melee1")
		animation_locked=true
		attack_facing_lock=true
		global.attacking=true
		if  is_on_floor():
			stop_move()
		else:
			velocity.x = direction * SPEED*0.5

func attack_range2():
		if not global.attacking:
			if is_on_floor():
				anim.play("range2")
			else:
				anim.play("range2_jump")
			animation_locked=true
			attack_facing_lock=true
			global.attacking=true
		#	gravity=30
		#	velocity.x = direction * SPEED*0.2
		#	velocity.y = direction * SPEED*0.2
			if  is_on_floor():
				stop_move()

func attack_range1():
		if not global.attacking:
			anim.play("range1")
#			if not is_on_floor():
#				velocity.y=-100
#			else:
#				anim.play("range1_jump")
			animation_locked=true
			attack_facing_lock=true
			global.attacking=true
		#	gravity=30
		#	velocity.x = direction * SPEED*0.2
		#	velocity.y = direction * SPEED*0.2
			if  is_on_floor():
				stop_move()
		

		

func if_dead():
	if global.player_health==0:
		if not animation_locked and is_on_floor():
			anim.play("dead")	
			animation_locked=true
			stop_move()
			dead=true
			return
		
			
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
					
				stop_move()
	#		else:
	#			velocity.x = move_toward(velocity.x, 0, SPEED)	
		
func update_facing_sprite():
	if direction and global.player_health!=0 and not attack_facing_lock:
		if direction < 0: # Check if moving left
			global.player_direction=-1
			if facing_right:
				scale.x = -1				
			facing_right=false
		else:
			global.player_direction=1
			if not facing_right:
				scale.x = -1 # Otherwise, don't flip
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
	if not global.attacking:
		anim.play("jump_up")
	velocity.y = JUMP_VELOCITY
	animation_locked=true
func double_jump():
	if not global.attacking:
		anim.play("double_jump")
	velocity.y = JUMP_VELOCITY*0.6
	has_double_jump=true
	animation_locked=true
	
func land():
	if not global.attacking:
		anim.play("jump_down")
	stop_move()
	global.attacking=false
	animation_locked=true
	
	
func stop_move():
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.y = move_toward(velocity.y, 0, SPEED)
	
	
	
	

func _on_animated_sprite_2d_animation_finished():
	if(anim.animation=="jump_down"):
		animation_locked=false
		attack_facing_lock=false		
	if(anim.animation=="jump_up"):
		animation_locked=false
#		print("finished")
	if(anim.animation=="double_jump"):
		animation_locked=false
	if(anim.animation=="attack_melee1"):
		animation_locked=false
		attack_facing_lock=false
		remove_child(melee_area)
		global.attacking=false
	if(anim.animation=="range2" or anim.animation=="range2_jump"):
		gravity=default_gravity
		animation_locked=false
		attack_facing_lock=false
		global.attacking=false
	if(anim.animation=="range1"):
		gravity=default_gravity
		animation_locked=false
		attack_facing_lock=false
		global.attacking=false
		









func _on_melee_attack_1_area_entered(area):
	pass # Replace with function body.


	


func _on_melee_timer_timeout():
	global.can_melee1=true


func _on_range_1_timer_timeout():
	global.can_range1=true


func _on_range_2_timer_timeout():
	global.can_range2=true
