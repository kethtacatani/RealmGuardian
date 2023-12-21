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
	label.text="%0.1f" % cooldown_time+"s"
	progress_bar.value =0
	progress_bar.texture_progress = texture_normal
	timer.wait_time =cooldown_time
	
func _process(delta):
	
	if cooldown_time!=global.range1_cooldown:
		cooldown_time= global.range1_cooldown
		timer.wait_time =cooldown_time
		label.text="%0.1f" % cooldown_time+"s"
		
	if not global.can_range1:
		label.text= "%0.1f" % timer.time_left
		progress_bar.value= int ((timer.time_left/cooldown_time)*100)
	
	if Input.is_action_just_pressed("fire_arrow") and not global.attacking and global.can_range1:
		if not isRun:
			isRun=true
			timer.start()
			label.show()
			if global.can_range1:
				global.can_range1=false
				global.attacking=true
	
		
		
func _on_timer_timeout():
	isRun=false
	label.text="%0.1f" % cooldown_time+"s"
	progress_bar.value=0
	global.can_range1=true


func _on_pressed():
	pass
		
		



