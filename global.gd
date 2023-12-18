extends Node


var knight_dead=true
var is_in_dialogue=false
var player_pos=0.0
var player_pos_y=0.0
var player_health=100
var player_direction=0
var max_health=150
var health=75
var level=5
var damage=2
var range2_damage=10
var range1_damage=5
var enemy_goblin_damage=2
var attacking=false


func player_hurt(points:float):
	if health-points<0:
		health=0
	else:
		health-=points
