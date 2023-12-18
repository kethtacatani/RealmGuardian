extends CharacterBody2D


var default_speed = getRandomValue(100,140)
var speed=default_speed
var JUMP_VELOCITY = -400.0
var animation_locked=false;
var entered_left=false
var entered_right=false
var teritory_entered= false
var teritory_entered_left= false
var teritory_entered_right= false
var health=20
var melee_attack1=false
var range1_attack=false
var range2_attack=false
var initialPosition;
var randomValue = getRandomValue(0,1)
var direction = 1 if randomValue>0 else -1
var next_idle=getRandomValue(2,7)
var last_idle=0
var facing_right=false
var position_limit=200
var anim_speed=0
var damage= global.enemy_goblin_damage
var hurt =true
var decreased=false
var randomScale= round_place(randf_range(1.3,1.8),1)
var max_health=health*randomScale



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0

@onready var anim= get_node("AnimatedSprite2D")
func _ready():	
	anim.play('runn')
#	anim.speed_scale(getRandomValue(0.8,1.2))
	initialPosition = global_position.x;
	anim_speed= $AnimatedSprite2D
	
#	var randomScale=1.8
	scale.x = randomScale
	scale.y =randomScale
	health*=randomScale
	damage *= randomScale
	print("global damage ",global.enemy_goblin_damage)
	print("health ",health)
	print("random scale ",randomScale)
	
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
	if not is_on_floor():
		velocity.y += gravity * delta
		if_dead()
#	print("random ",getRandomValue(0,9))
	check_hurt()
	random_idle()
	# Handle Jump.
	
	var movement = speed * delta * direction
	position.x += movement
	if not teritory_entered:
		if position.x <= initialPosition-position_limit:
			direction = 1
		elif  position.x > initialPosition+position_limit:
			direction = -1
	if health!=0:
		if direction== -1:
				anim.flip_h=true
				facing_right=false
		else:
				anim.flip_h=false
				facing_right=true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	move_and_slide()
	check_teritory()

	if not animation_locked:
		if (entered_left or entered_right) and global.health>0:
			if entered_left and facing_right:
				print("left")
				direction=-1
			elif entered_right and not facing_right:
				direction=1
				print("right")
			
			anim.play("attack")
			anim_speed.speed_scale= randf_range(0.8,1.5)
		
			speed=0
			animation_locked=true
		else:
			if not animation_locked:
				anim.play("runn")
				anim_speed.speed_scale=1
				speed=default_speed
				
func random_idle():
	var current_seconds = Time.get_ticks_msec() / 1000.0
	if current_seconds-last_idle > next_idle and not teritory_entered:
		anim.play("idle")
		speed=0
		animation_locked=true
		last_idle=current_seconds
		next_idle=randi_range(4,7)
		if getRandomValue(0,1)<1:
			direction= -1 if direction==1 else 1
		
	
#func getRandomValueDelay():
#	var timer :Timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 2
#	timer.one_shot = false
#	timer.autostart=false
#	timer.timeout.connect(func():print("fcuk"))
#	timer.start()

func getRandomValue(first, second):
	return randi_range(first,second)

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func check_hurt():
	pass

func decrease_health():
	print("decrease")
	var damage=0
	if melee_attack1 or range1_attack or range2_attack:
		
		if melee_attack1:
			damage=global.damage
			print("attack1")
		elif range1_attack:
			damage=global.range1_damage
			print("range1")
			
		elif range2_attack:
			damage=global.range2_damage
			print("range2")
		
		anim.play("hurt")
		speed=0
		animation_locked=true
		if health-damage<=0:
			health=0
		else:
			health-=damage
		print(health)
			
func if_dead():
	if health==0:
		anim.play("dead")	
		animation_locked=true

func _on_area_2d_body_entered(body):
	if body.name=='hero':
		entered_left=true
		animation_locked=false
			
func _on_area_2d_body_exited(body):
	if body.name=='hero':
		print("anim idle")
		entered_left=false
		


func _on_animated_sprite_2d_animation_finished():
	
	if(anim.animation=="attack"):
		animation_locked=false
		if entered_left or entered_right:
			global.player_hurt(damage)
	if(anim.animation=="hurt"):
		animation_locked=false
		
		
	if(anim.animation=="dead"):
		animation_locked=false
		self.queue_free()
	if(anim.animation=="idle"):
		animation_locked=false


func _on_hit_mark_area_entered(area):
	if area.name=="melee_attack1":
		melee_attack1=true
		range1_attack=false
		range2_attack=false
		var timer = $Timer
		timer.wait_time=0.3
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
		position_limit=600
		entered_right=true
		animation_locked=false


func _on_area_2d_right_body_exited(body):
	if body.name=='hero':
		position_limit=200
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
	if global.player_pos > initialPosition-position_limit*3 and global.player_pos < initialPosition+position_limit*3:
		teritory_entered=true
		
		if teritory_entered_left:
			direction= -1
		elif teritory_entered_right:
			direction=1
	else:
		teritory_entered=false
		


func _on_timer_timeout():
	decrease_health()
