extends TextureProgressBar




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = float(global.player_health)/float(global.player_max_health) * 100

#	
	

