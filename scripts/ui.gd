extends CanvasLayer

signal reset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.character:
		%screens/igui/VBoxContainer/HBoxContainer/stam.text = str(player.character.stamina)
	%screens/igui/VBoxContainer/HBoxContainer/lives.text = str(player.lives)


func _on_button_pressed():
	emit_signal("reset")
