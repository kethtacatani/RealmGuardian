extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit") and global.game_finished:
		get_tree().quit()


func _on_area_2d_body_entered(body):
	if body.name=="hero":
		print("end")
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"end_diag")
