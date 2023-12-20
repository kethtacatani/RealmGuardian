extends CharacterBody2D


var default_speed = global.getRandomValue(100,140)
var speed=default_speed
var animation_locked=false;
var entered_left=false
var entered_right=false
var teritory_entered= false
var teritory_entered_left= false
var teritory_entered_right= false
var health=15
var melee_attack1=false
var range1_attack=false
var range2_attack=false
var initialPosition;
var randomValue = global.getRandomValue(0,1)
var direction = 1 if randomValue>0 else -1
var next_idle=global.getRandomValue(2,7)
var last_idle=0
var facing_right=false
var position_limit=200
var anim_speed=0
var damage= global.enemy_bird_damage
var randomScale= global.round_place(randf_range(1.5,1.8),1)
var max_health=health*randomScale
var dead =false
var timer_heal
var exp=4
var fire_out_timer
var healing=false
var bird_fire
var fire_out=true
var facing_left_on_attack=false
var fire_x=0
var fire_y=0
var fire_rotation=0
var fire_y_direction=1


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0
@onready var anim= get_node("AnimatedSprite2D")
func _ready():	
	fire_out_timer = $FireOut
	anim.play('fly')
	initialPosition = global_position.x;
	anim_speed= $AnimatedSprite2D
	timer_heal=$TimerHeal
	bird_fire=$bird_fire
	remove_child(bird_fire)
	
#	var randomScale=1.8
	scale.x = randomScale
	scale.y =randomScale
	health*=randomScale
	damage *= randomScale
	exp *= randomScale


func _physics_process(delta):
	# Add the gravity
	if not player_nearby():
		return
	if_dead()
	check_teritory()
	var movement = speed * delta * direction
	position.x += movement
	
	if not global.bird_hurt:
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
	
	if fire_out:		
		if entered_left:
			bird_fire.direction= -1
			bird_fire.anim.flip_h=false
		elif entered_right:
			bird_fire.direction= 1
			bird_fire.anim.flip_h=true
			
	if not global.bird_hurt and not healing:
		timer_heal.start()
		healing=true
		
	if not animation_locked:
		if (entered_left or entered_right) and global.player_health>0 and fire_out and not dead:
			if entered_left and facing_right:
				direction=-1
				anim.flip_h=true
			elif entered_right and not facing_right:
				direction=1
				anim.flip_h=false
			global.bird_hurt=true
			anim.play("attack")
			speed=0
			fire_direction(fire_x,fire_y)
			var timer= $FireTimer
			timer.start()
			bird_fire.anim.play("fire")
			fire_out_timer.start()
			fire_out=false
			anim_speed.speed_scale= randf_range(0.8,1.5)
			speed=0
			animation_locked=true
		else:
			if not animation_locked:
				anim.play("fly")
				anim_speed.speed_scale=1
				if fire_out:
					speed=default_speed
	random_idle()
	move_and_slide()
	
func if_dead():
	if health==0 and not dead:
		anim.play("dead")	
		animation_locked=true
		velocity.y= 1*300
		$DeadGone.start()

func decrease_health():
	global.bird_hurt=true
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
			
			
func random_idle():
	var current_seconds = Time.get_ticks_msec() / 1000.0
	if current_seconds-last_idle > next_idle and not global.bird_hurt and not teritory_entered:
		anim.play("idle")
		speed=0
		animation_locked=true
		last_idle=current_seconds
		next_idle=randi_range(4,7)
		if global.getRandomValue(0,1)<1 and not fire_out:
			direction= -1 if direction==1 else 1


func _on_animated_sprite_2d_animation_finished():
	if(anim.animation=="idle"):
		animation_locked=false
	if(anim.animation=="attack"):
		animation_locked=false
	if(anim.animation=="hurt"):
		animation_locked=false
	if(anim.animation=="dead"):
		dead=true				
		animation_locked=false
		global.player_add_exp(exp)
	if(anim.animation=="dead_land"):
		velocity.y=50
		


func _on_attack_area_left_body_entered(body):
	if body.name=="hero":
		entered_left=true

		
		
		


func _on_attack_area_right_body_entered(body):
	if body.name=="hero":
		entered_right=true
		
		
		
	


func _on_attack_area_right_body_exited(body):
	if body.name=="hero":
		entered_right=false

func _on_attack_area_left_body_exited(body):
	if body.name=="hero":
		entered_left=false




func _on_fire_out_timeout():
	$FireNotHit.start()
	bird_fire.anim.play("hit")	
	
#	print("fire out")

func check_teritory():
	if global.player_pos > initialPosition-position_limit*4.5 and global.player_pos < initialPosition+position_limit*4.5:
		teritory_entered=true
		
		if global.bird_hurt:		
			if teritory_entered_left:
				print("left", randomScale)
				direction= -1
			elif teritory_entered_right:
				print("rigt",randomScale)
				direction=1
				
	else:
		teritory_entered=false
		global.bird_hurt=false
		

func _on_fire_timer_timeout():
	if not dead:
		add_child(bird_fire)
		bird_fire.add_child(bird_fire.collision)
		bird_fire.add_child(bird_fire.bird_fire)
		if direction==1:
			bird_fire.global_position.x=global_position.x+90
			bird_fire.global_position.y=global_position.y+30
		if direction== -1:
			bird_fire.global_position.x=global_position.x-70
			bird_fire.global_position.y=global_position.y+30
	
func fire_direction(x,y):
	bird_fire.velocity.x = direction * bird_fire.speed*x
	bird_fire.velocity.y = fire_y_direction * bird_fire.speed*y
	bird_fire.rotation_degrees=fire_rotation
	
func fire_direction1():
	fire_x=0.4
	fire_y=0.8
	fire_y_direction=1
func fire_direction2():
	fire_x=0.9
	fire_y=0.8
	fire_y_direction=1

func fire_direction3():
	fire_x=0.9
	fire_y=0.4
	fire_y_direction=1

func fire_direction4():
	fire_x=0.9
	fire_y=0.18
	fire_y_direction=1
func fire_direction5():
	fire_x=0.9
	fire_y=0.15
	fire_y_direction=-1




func _on_area_2d_13_body_entered(body):
	if body.name=="hero":
		fire_direction1()
		


func _on_area_2d_3_11_body_entered(body):
	if body.name=="hero":
		fire_direction3()
			


func _on_area_2d_3_14_body_entered(body):
	if body.name=="hero":
		fire_direction1()


func _on_area_2d_2_12_body_entered(body):
	if body.name=="hero":
		fire_direction2()


func _on_area_2d_4_23_body_entered(body):
	if body.name=="hero":
		fire_direction2()


func _on_area_2d_5_22_body_entered(body):
	if body.name=="hero":
		fire_direction3()


func _on_area_2d_6_21_body_entered(body):
	if body.name=="hero":
		fire_direction4()


func _on_fire_not_hit_timeout():
	remove_child(bird_fire)
	fire_out=true


func _on_area_2d_7_33_body_entered(body):
	if body.name=="hero":
		fire_direction5()


func _on_area_2d_8_32_body_entered(body):
	if body.name=="hero":
		fire_direction5()


func _on_area_2d_9_31_body_entered(body):
	if body.name=="hero":
		fire_direction5()


func _on_area_2d_2_15_body_entered(body):
	if body.name=="hero":
		fire_direction2()


func _on_area_2d_16_body_entered(body):
	if body.name=="hero":
		fire_direction3()


func _on_area_2d_6_24_body_entered(body):
	if body.name=="hero":
		fire_direction2()


func _on_area_2d_5_25_body_entered(body):
	if body.name=="hero":
		fire_direction3()


func _on_area_2d_4_26_body_entered(body):
	if body.name=="hero":
		fire_direction4()


func _on_area_2d_9_34_body_entered(body):
	if body.name=="hero":
		fire_direction5()

	
func _on_area_2d_8_35_body_entered(body):
	if body.name=="hero":
		fire_direction5()


func _on_area_2d_7_36_body_entered(body):
	if body.name=="hero":
		fire_direction5()


func _on_hit_mark_area_entered(area):
	if area.name=="melee_attack1":
		melee_attack1=true
		range1_attack=false
		range2_attack=false
		decrease_health()
		
		
		
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


func _on_timer_heal_timeout():
	if not global.bird_hurt and health!=max_health:
		if health<max_health:
			health+=2*randomScale
			print(health)
			
		elif health>=max_health:
			healing=false



func _on_area_2d_body_entered(body):
	healing=false


func _on_hit_mark_body_entered(body):
	if body.name=="StaticBody2D":
		velocity.y=0
		speed=0
		anim.play("dead_land")
		animation_locked=true


func _on_dead_gone_timeout():
	self.queue_free()


func _on_teritory_left_body_entered(body):
	if body.name=="hero":
		teritory_entered_left=true
		teritory_entered_right=false


func _on_teritory_right_body_entered(body):
	if body.name=="hero":
		teritory_entered_left=false
		teritory_entered_right=true


func _on_teritory_right_body_exited(body):
	if body.name=="hero":
		teritory_entered_right=false


func _on_teritory_left_body_exited(body):
	if body.name=="hero":
		teritory_entered_left=false
func player_nearby():
	if global.player_pos > initialPosition-position_limit*6 and global.player_pos < initialPosition+position_limit*6:
		return true
	else:
		return false
