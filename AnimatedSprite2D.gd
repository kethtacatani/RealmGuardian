extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
@onready var anim= get_node("CollisionShape2D/AnimatedSprite2D")
func _ready():	
	anim.play('default')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CollisionShape2D.set_deferred("disabled",true);
