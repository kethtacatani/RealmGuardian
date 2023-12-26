extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	$AudioStreamPlayer2D.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	


func _on_portal_body_entered(body):
	if body.name=="hero":
		global.is_on_castle=true
		get_tree().change_scene_to_file("res://castle.tscn")
		
