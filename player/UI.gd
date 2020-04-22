extends Control

var i:int = 0

onready var lb = $"game ui/buttons/move/left"
onready var rb = $"game ui/buttons/move/right"
onready var ab = $"game ui/buttons/act/attk"
onready var jb = $"game ui/buttons/act/jump"

func ready():
	$settings/music.value = AudioServer.get_bus_volume_db(1)
	$settings/sfx.value = AudioServer.get_bus_volume_db(2)
	Globals.connect("end", self, "menu")
	$settings/scale.value = $"game ui/buttons".rect_scale.x

func _process(delta):
	if Globals.inGame:
		if lb.is_pressed():
			Globals.emit_signal("left")
		if rb.is_pressed():
			Globals.emit_signal("right")
		if ab.is_pressed():
			Globals.emit_signal("attk")
		if jb.is_pressed():
			Globals.emit_signal("jump")
	
	if $"main menu/screen right/settings".is_pressed():
		$press.play()
		$"main menu".visible = false
		$settings.visible = true
		$"game ui".visible = true
	
	if $"main menu/screen right/start".is_pressed():
		$press.play()
		$"main menu".visible = false
		$"game ui".visible = true
		lb.visible = true
		rb.visible = true
		ab.visible = true
		jb.visible = true
		Globals.emit_signal("start")
	
	if $"main menu/screen right/web".is_pressed():
		$press.play()
		OS.shell_open("https://ostally001.wixsite.com/oasicomms/about")
	
	$"main menu/stats/candy".text = "Candy\n" + str(Globals.max_candy)
	$"main menu/stats/dist".text = "Dist.\n" +str(Globals.max_dist)
	$"main menu/stats/time".text = "Time\n" +str(Globals.max_time)
	$"main menu/stats/snakes".text = "Snakes\n" +str(Globals.snakes_killed)
	
	$"main menu/screen left/charName".text = Globals.curr_char[2]
	
	if Globals.debug_msg:
		$"game ui/stats/debug".text = Globals.debug_msg
	if Globals.inGame:
		$"game ui/stats/time".text = "Time\n" + str(Globals.time) + "\nsecs"
		$"game ui/stats/candy".text = "Candy\n" + str(Globals.candy)
		$"game ui/stats/dist".text = "Dist.\n" + str(Globals.dist)
		$"game ui/stats/snakes".text = "Snakes\n" +str(Globals.snakes_killed)


func menu():
	print("to main menu")
	$"game ui".visible = false
	$settings.visible = false
	$"main menu".visible = true

func _on_scale_value_changed(value):
	$"game ui/buttons".rect_scale.x = value
	$"game ui/buttons".rect_scale.y = value


func _on_back_pressed():
	$back.play()
	Globals.emit_signal("end")


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_charRight_pressed():
	i += 1
	if i > len(Globals.characters) - 1:
		i = 0
	while not Globals.characters[i][1]:
		i += 1
		if i > len(Globals.characters) - 1:
			i = 0
	$press.play()
	Globals.switch_char(Globals.characters[i])
	print(Globals.curr_char[2])
#	else:
#		$back.play()
#		print(Globals.characters[i])

func _on_charLeft_pressed():
	i -= 1
	if i < 0:
		i = len(Globals.characters) - 1

	while not Globals.characters[i][1]:
		i -= 1
		if i < 0:
			i = len(Globals.characters) - 1
	$press.play()
	Globals.switch_char(Globals.characters[i])
	print(Globals.curr_char[2])
#	else:
#		$back.play()
#		print(Globals.characters[i])
		
	
