extends TileMap


var delOk1 = false
var delOk2 = false

var ticks = 0
var secs = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delOk2:
		ticks += delta
		if ticks >= 1:
			secup()
		if secs>= 3:
			queue_free()
		

func _on_VisibilityNotifier2D_screen_entered():
	delOk1 = true

func _on_VisibilityNotifier2D_screen_exited():
	delOk2 = true
		
		
func secup():
	secs += 1
