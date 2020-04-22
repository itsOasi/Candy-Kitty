extends Node2D

export var max_spd:int
export var min_spd:int

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("start", self, "start")
	Globals.connect("end", self, "end")

#chunk of world to spawn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.inGame:
		#move along x axis at game speed
		var spd = (Globals.game_spd * (Globals.dist*.1)) * delta
		if spd < min_spd:
			spd = min_spd
		if spd > max_spd:
			spd = max_spd
		if Globals.objsOnScreen > 0:
			spd /= Globals.objsOnScreen
#		Globals.debug_msg = str(round(spd))
		$Camera2D.position.x += spd 
		#follow character along y axis
		$Camera2D.position.y += (((Globals.charPos.y - $Camera2D.position.y) *.025))

#starts game
func start():
	Globals.inGame = true
	
func end():
	Globals.inGame = false
	#start transition to main menu
	$CanvasLayer/Control.menu()
#	$platSpawn.position = Vector2(779, 306)
	#reset positions
	Globals.endGame()
	$Camera2D.position = Vector2(4159.17, 249.64)
	Globals.player.position = Vector2(2559.17, 84.677)
	$spawn.position.x = 8192

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
