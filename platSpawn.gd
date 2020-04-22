extends Node2D

export var grid_size:int

var secs = 0
var ticks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if secs >= 5:
		place_block()
		move()
		secs = 0
	ticks += delta
	if ticks>= 1:
		secup()
#	Globals.debug_msg = str(secs)

func move():
	var last_pos = position.x
	position.x += grid_size
	var delta_pos = position.x - last_pos
func place_block():
	var platform = null
	var p = randi() % len(Globals.Plat)
	platform = Globals.Plat.values()[p].instance()
	platform.position.x = position.x
	get_parent().add_child(platform)
	Globals.debug_msg = str(platform.name)

func secup():
	secs += 1
	ticks = 0
