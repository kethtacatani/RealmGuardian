extends CharacterBody2D

var default_speed=450
var speed = default_speed #380
var default_jump_velocity= -750
var JUMP_VELOCITY = default_jump_velocity
var motion= Vector2()
var prevX=0
var prevY=0
var has_double_jump=false
var animation_locked= false
var attack_facing_lock=false
var direction=1
var was_in_air= false
var facing_right=true
var health_bar
var dead= false
var default_gravity=1200
var can_dash=true



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = default_gravity
var melee_area

@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")

func _ready():	
	if global.restart:
		global.player_health=global.player_max_health
		global.restart=false
	anim.play('idle')
	global.player_direction=direction
	melee_area=$melee_attack1
	remove_child(melee_area)
	
	

func _physics_process(delta):
	# Add the gravity.
#	print("x: ",prevX)
#	print("y: ",prevY)
#	print(global_position)

	
		

	if global.game_finished:
		$GameFinishAudio.play()

	if_dead()
	global.player_pos= global_position.x
	global.player_pos_y= global_position.y
	
	if global.new_game && is_on_floor():
		global.new_game=false
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"start")
			
	if global.is_on_castle:
		$CollisionShape2D/AnimatedSprite2D/Camera2D.limit_right = 6179
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
			return
	else:
			pass
			
	if can_dash:
		direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_accept") and not dead:
		#double jump
		if is_on_floor() and not global.attacking:
			jump()
		elif not has_double_jump and not is_on_floor():
			double_jump()
	#handle melee_attack1
	if Input.is_action_just_pressed("melee_attack1") and not dead and global.can_melee1 and can_dash:
		attack_melee1()
	if Input.is_action_just_pressed("fire_arrow") and not dead and global.can_range1 and can_dash:
		attack_range1()
		
	if Input.is_action_just_pressed("fire_magic") and not dead and global.can_range2 and can_dash:
		attack_range2()
		
	if Input.is_action_just_pressed("dash") and not dead and global.can_dash and not global.attacking:
		anim.play("dash")
		$DashAudio.play()
		can_dash=false
		direction= 1 if facing_right else -1
		animation_locked=true
		speed=2000
		attack_facing_lock=true
		velocity.x = direction * speed
			
	
	
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
		$MeleeAudio.play()
		animation_locked=true
		attack_facing_lock=true
		if  is_on_floor():
			stop_move()
		else:
			velocity.x = direction * speed*0.5

func attack_range2():
		if not global.attacking:
			if is_on_floor():
				anim.play("range2")
			else:
				anim.play("range2_jump")
			animation_locked=true
			attack_facing_lock=true
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
			$TimerDead.start()
			stop_move()
			dead=true
			return
		
			
func update_animation():
	if not animation_locked:
		if direction:
			velocity.x = direction * speed				
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
			velocity.x = direction * speed*0.5
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
	velocity.x = move_toward(velocity.x, 0, speed)
	velocity.y = move_toward(velocity.y, 0, speed)
	
	
	
	

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
		global.attacking=false
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
	if(anim.animation=="dash"):
		print("finished")
		can_dash=true
		global.attacking=false
		speed=default_speed
		animation_locked=false
		attack_facing_lock=false
		










func _on_timer_dead_timeout():
	get_tree().change_scene_to_file("res://game_over.tscn")
