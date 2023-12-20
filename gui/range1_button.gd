extends TextureButton

var cooldown_time= global.range1_cooldown
var isRun = false
var label
var progress_bar
var timer
func _ready():
	label = $Label
	progress_bar=$TextureProgressBar
	timer= $Timer
	label.hide()
	progress_bar.value =0
	progress_bar.texture_progress = texture_normal
	timer.wait_time =cooldown_time
	
func _process(delta):
	label.text= "%0.1f" % timer.time_left
	progress_bar.value= int ((timer.time_left/cooldown_time)*100)
	
	if Input.is_action_just_pressed("fire_arrow"):
		print("pressed")
		if not isRun:
			isRun=true
			timer.start()
			label.show()
	
		
		
func _on_timer_timeout():
	isRun=false
	label.hide()
	progress_bar.value=0


func _on_pressed():
	pass
		
		


