extends Node3D

var character = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ui.connect("reset", reset_game)
	reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if character:
		var cam_tween = create_tween()
		cam_tween.tween_property(%Camera3D, "position", Vector3(character.position.x, character.position.y +3, %Camera3D.position.z), 1)

func reset_game():
	if character:
		character.queue_free()
	player.spawn_character(%Marker3D.position)
	character = player.character
	character.connect("died", reset_game)
