extends Node3D

var c = preload("res://objects/character.tscn")
var character = null

var lives = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if character:
		character.move(input_dir)
		if (Input.is_action_pressed("jump") or Input.is_action_pressed("up")):
			character.jump()
		if Input.is_action_just_released("jump") or Input.is_action_just_released("up"):
			character.jump_rel()

func spawn_character(position):
	if !lives:
		return
	character = c.instantiate()
	character.position = position
	add_child(character)
	add_life(-1)

func add_life(amnt):
	lives += amnt
