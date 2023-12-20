extends Node

var player_default_regen=100.0
var player_regen_perk=1.0
var player_regen= player_default_regen*player_regen_perk

var can_melee1=true
var can_range1=true
var can_range2=true
var melee1_cooldown=1
var range1_cooldown=3
var range2_cooldown=10

var knight_dead=true
var is_in_dialogue=false
var player_pos=0.0
var player_pos_y=0.0
var player_health=100
var player_direction=0
var player_max_health=100
var level=1
var current_exp=0
var max_exp=10
var damage=2
var range2_damage=10
var range1_damage=4
var enemy_goblin_damage=3
var enemy_bird_damage=2
var attacking=false

var goblin_hurt=false
var bird_hurt=false
var player_hit

func player_hurt(points:float):
	if player_health-points<0:
		player_health=0
		
	else:
		player_health-=points
func player_add_exp(exp:float):
	if current_exp+exp>=max_exp:
		level+=1
		current_exp= (current_exp+exp)-max_exp
		max_exp*1.5
		player_health+=player_max_health*1.1-player_max_health
		player_max_health*=1.1
		player_default_regen*=1.15
	elif current_exp+exp<max_exp:
		current_exp+=exp
func getRandomValue(first, second):
	return randi_range(first,second)

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
