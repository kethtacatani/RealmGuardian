extends Node


var player_max_health=100
var player_health=100
var player_regen_rate:float=1.0  #percent relative to max health
var player_regen:float= (player_regen_rate/100)*player_max_health
var aquired_orb=""

var can_melee1=true
var can_range1=true
var can_range2=true
var can_dash=true
var cooldown_reduction:float=1
var melee1_cooldown=1-((cooldown_reduction/100)*1)
var range1_cooldown=3-((cooldown_reduction/100)*3)
var range2_cooldown=10-((cooldown_reduction/100)*10)
var dash_cooldown=5-((cooldown_reduction/100)*5)

var game_finished=false
var new_game=false
var knight_dead=false
var is_on_castle=false
var fairy_talked=false
var is_in_dialogue=false
var player_pos=0.0
var player_pos_y=0.0
var player_direction=0
var level=1
var current_exp=0
var max_exp=10
var orb_received=false
var restart=false

var damage_addition:float=1
var damage=7+((damage_addition/100)*7)
var range2_damage=15+((damage_addition/100)*15)
var range1_damage=9+((damage_addition/100)*9)

var damage_reduction:float=1 #percent relative to damage received
var enemy_goblin_damage=2
var enemy_bird_damage=1
var enemy_mons_damage=3
var attacking=false

var goblin_hurt=false
var mons_hurt=false
var bird_hurt=false
var enemy_hurt=false
var player_hit
var ponts

func player_hurt(points:float):
	if player_health-points<0:
		player_health=0
		
	else:
		player_health-=points-((damage_reduction/100)*points)
func player_add_exp(exp:float):
	if current_exp+exp>=max_exp:
		level+=1
		current_exp= (current_exp+exp)-max_exp
		max_exp*1.5
		player_health+=player_max_health*1.1-player_max_health
		player_max_health*=1.1
	elif current_exp+exp<max_exp:
		current_exp+=exp

func received_orb(orb:String):
	aquired_orb=orb
	if aquired_orb=="Shielding Aegis":
		damage_reduction+=10
	if aquired_orb=="Bladebane Radiance":
		damage_addition+=10
	if aquired_orb=="Chrono Essentia":
		cooldown_reduction+=10
	if aquired_orb=="Revitalizing Seraph":
		player_regen_rate+=5
	refresh_attributes()

func refresh_attributes():
	player_regen= (player_regen_rate/100)*player_max_health
	
	damage=2+((damage_addition/100)*2)
	range2_damage=10+((damage_addition/100)*10)
	range1_damage=4+((damage_addition/100)*4)
	
	melee1_cooldown=1-((cooldown_reduction/100)*1)
	range1_cooldown=3-((cooldown_reduction/100)*3)
	range2_cooldown=10-((cooldown_reduction/100)*10)
	dash_cooldown=5-((cooldown_reduction/100)*5)
	
func getRandomValue(first, second):
	return randi_range(first,second)

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
