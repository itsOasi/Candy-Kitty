extends Node2D

var bias

var candyChance
var boxChance

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("end", self, "end")
	candyChance = randi() % 50
	boxChance = randi() % 25
	bias = max(candyChance, boxChance)

func end():
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
