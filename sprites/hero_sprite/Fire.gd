extends Area2D


var SPEED = 450.0 #380
@onready var anim= get_node("AnimatedSprite2D")


func _ready():	
	anim.play('fire2')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
