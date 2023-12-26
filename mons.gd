extends CharacterBody2D


var default_speed = global.getRandomValue(100,140)
var speed=default_speed
var animation_locked=false;
var entered_left=false
var entered_right=false
var teritory_entered= false
var teritory_entered_left= false
var teritory_entered_right= false
var health=30
var melee_attack1=false
var range1_attack=false
var range2_attack=false
var initialPosition;
var initialPosition_y;
var randomValue = global.getRandomValue(0,1)
var direction = 1 if randomValue>0 else -1
var next_idle=global.getRandomValue(2,7)
var last_idle=0
var facing_right=false
var position_limit=200
var position_limit_y=200
var teritory_limit=600
var anim_speed=0
var damage= global.enemy_mons_damage
var randomScale= global.round_place(randf_range(1.3,1.5),1)
var max_health=health*randomScale
var dead =false
var timer_heal
var exp=5
var timer
var healing=false




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

@onready var anim= get_node("AnimatedSprite2D")
func _ready():	
	timer = $Timer
	anim.play('runn')
#	anim.speed_scale(getRandomValue(0.8,1.2))
	initialPosition = global_position.x;
	initialPosition_y = global_position.y;
	anim_speed= $AnimatedSprite2D
	timer_heal=$TimerHeal
	
#	var randomScale=1.8
	scale.x = randomScale
	scale.y =randomScale
	health*=randomScale
	damage *= randomScale
	exp *= randomScale
	
	var vector_y=0
	if randomScale==1.3:
		vector_y=4
	elif randomScale==1.4:
		vector_y=1
	elif randomScale==1.5:
		vector_y=-2
	elif randomScale==1.6:
		vector_y=-5
	elif randomScale==1.7:
		vector_y=-7
	elif randomScale==1.8:
		vector_y=-8
	anim.offset= Vector2(0,vector_y)
func _physics_process(delta):
	# Add the gravity.
	
	if dead:
		anim.play("dead_dead")
		animation_locked=true
		return
	if not player_nearby():
		return
	if not is_on_floor():
		velocity.y += gravity * delta
		if_dead()
#	print("random ",getRandomValue(0,9))
	random_idle()
	# Handle Jump.
	if health<=0:
		return
	
	var movement = speed * delta * direction
	position.x += movement
	if not global.enemy_hurt:
		if position.x <= initialPosition-position_limit:
			direction = 1
		elif  position.x > initialPosition+position_limit:
			direction = -1
	if health!=0 and not animation_locked:
		if direction== -1:
				anim.flip_h=true
				facing_right=false
		else:
				anim.flip_h=false
				facing_right=true


	if not global.enemy_hurt and not healing:
		timer_heal.start()
		healing=true
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	move_and_slide()
	check_teritory()

	if not animation_locked and not dead:
		if (entered_left or entered_right) and global.player_health>0:
			if entered_left and facing_right:
				direction=-1
			elif entered_right and not facing_right:
				direction=1
			global.enemy_hurt=true
			anim.play("attack")
			anim_speed.speed_scale= randf_range(0.8,1.5)
		
			speed=0
			animation_locked=true
			$AttackAudio.play()
		else:
			if not animation_locked:
				anim.play("runn")
				anim_speed.speed_scale=1
				speed=default_speed
				
func random_idle():
	var current_seconds = Time.get_ticks_msec() / 1000.0
	if current_seconds-last_idle > next_idle and not global.enemy_hurt :
		anim.play("idle")
		speed=0
		animation_locked=true
		last_idle=current_seconds
		next_idle=randi_range(4,7)
		if global.getRandomValue(0,1)<1:
			direction= -1 if direction==1 else 1
		
	
#func getRandomValueDelay():
#	var timer :Timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 2
#	timer.one_shot = false
#	timer.autostart=false
#	timer.timeout.connect(func():print("fcuk"))
#	timer.start()




func decrease_health():
	if player_nearby():
		global.enemy_hurt=true
	var damage=0
	if melee_attack1 or range1_attack or range2_attack:
		if melee_attack1:
			damage=global.damage
		elif range1_attack:
			damage=global.range1_damage
			
		elif range2_attack:
			damage=global.range2_damage
		
		anim.play("hurt")
		speed=0
		animation_locked=true
		if health-damage<=0:
			health=0
		else:
			health-=damage
			
func if_dead():
	if health==0 and not dead:
		$DieAudio.play()
		anim.play("dead")	
		remove_child($hit_mark)
		animation_locked=true

func _on_area_2d_body_entered(body):
	if body.name=='hero':
		entered_left=true
		animation_locked=false
			
func _on_area_2d_body_exited(body):
	if body.name=='hero':
		entered_left=false
		


func _on_animated_sprite_2d_animation_finished():
	
	if(anim.animation=="attack"):
		animation_locked=false
		if entered_left or entered_right:
#			print("damage ", damage)
			global.player_hurt(damage)
#			print(global.ponts)
	if(anim.animation=="hurt"):
		animation_locked=false
		
		
	if(anim.animation=="dead"):
		dead=true		
		global.player_add_exp(exp)
#		$TimerDead.start()
		
	if(anim.animation=="idle"):
		animation_locked=false


func _on_hit_mark_area_entered(area):
	if area.name=="melee_attack1":
		melee_attack1=true
		range1_attack=false
		range2_attack=false
		timer.start();
		
		
		
	if area.name=="range2":
		melee_attack1=false
		range1_attack=false
		range2_attack=true
		decrease_health()
		
	if area.name=="range1":
		melee_attack1=false
		range1_attack=true
		range2_attack=false
		decrease_health()






#func _on_animated_sprite_2d_animation_changed():
#	if(anim.animation=="hurt"):
#		if health-global.damage<0:
#			health=0
#		else:
#			health-=global.damage


func _on_area_2d_right_body_entered(body):
	if body.name=='hero':
		entered_right=true

func _on_area_2d_right_body_exited(body):
	if body.name=='hero':
		entered_right=false


func _on_teritory_left_body_entered(body):
	if body.name=='hero':
		teritory_entered_left=true
		teritory_entered_right=false	
func _on_teritory_right_body_entered(body):
	if body.name=='hero':
		teritory_entered_right=true		
		teritory_entered_left=false
			
		
		
func check_teritory():
	if global.player_pos > initialPosition-position_limit*4.5 and global.player_pos < initialPosition+position_limit*4.5:
		teritory_entered=true
		if global.enemy_hurt and player_nearby(): 		
			if teritory_entered_left:
				direction= -1
			elif teritory_entered_right:
				direction=1
				
	else:
		teritory_entered=false
		if player_nearby():
			global.enemy_hurt=false
#		teritory_entered_left=false
#		teritory_entered_right=false
		
func player_nearby():
	if global.player_pos > initialPosition-position_limit*7 and global.player_pos < initialPosition+position_limit*7:
			if global.player_pos_y > initialPosition_y-position_limit_y and global.player_pos_y < initialPosition_y+position_limit_y:
				return true
			else:
				return false
		
func _on_timer_timeout():
	decrease_health()
	
func _on_timer_heal_timeout():
	if not global.enemy_hurt:
		if health<max_health:
			health+=2*randomScale
		elif health>=max_health:
			healing=false



func _on_timer_dead_timeout():
	self.queue_free()
