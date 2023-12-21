extends TextureProgressBar

@onready var parent = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=parent.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if parent.teritory_entered and not parent.dead:
		visible=true
	else:
		visible=false
	value = parent.health
