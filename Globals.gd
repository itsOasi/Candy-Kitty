extends Node

signal start
signal end

#player's selected character
var curr_char
var player

#input
signal attk
signal jump
signal jrel
signal left
signal right

#player's top scores
var max_candy = 0
var max_dist = 0
var max_time = 0
var snakes_killed = 0

#player's scores in game
var candy = 0
var dist = 0


#characters position in game
var startPos
var charPos = Vector2()
var ground = 700


#time management
var ticks:float
var time:int
var ptime:int

#gravity and game speed
export var grav = 50
export var game_spd:int = 100
var objsOnScreen:int = 1

var debug_msg = null
var inGame = false

#playable characters
var characters = [
	[preload("res://player/Candy.tscn"), true, "Candy"],
	[preload("res://player/Doge.tscn"),  true if max_candy >= 100 else false, "Doge"],
	[preload("res://player/Mouse.tscn"), true if snakes_killed >= 50 else false, "Paddles"],
	[preload("res://player/Squirrel.tscn"), true if max_dist >= 5000 else false, "Cheeky"],
	[preload("res://player/Birdie.tscn"), true if max_time >= 500 else false, "Peeps"],
]

export var Plat = {
	chunk_1 = preload("res://env/chunk 1.tscn"),
	chunk_2 = preload("res://env/chunk 2.tscn"),
	chunk_3 = preload("res://env/chunk 3.tscn"),
	chunk_4 = preload("res://env/chunk 1.tscn"),
	chunk_5 = preload("res://env/chunk 1.tscn"),
}

export var Candy = {
	hard = null,
	choco = null,
	jbean = null,
	gumdr = null
}

export var Ctnr = {
	bag = null,
	stock = null,
	freight = null,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	loadGame()
	curr_char = characters[0]
	player = curr_char[0].instance()
	add_child(player)
	player.position = Vector2(2559.17, 84.677)
	print(curr_char[2])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_W):
		emit_signal("jump")
	if not Input.is_key_pressed(KEY_W):
		emit_signal("jrel")
	if Input.is_key_pressed(KEY_A):
		emit_signal("left")
	if Input.is_key_pressed(KEY_D):
		emit_signal("right")
	if Input.is_key_pressed(KEY_SLASH):
		emit_signal("attk")
	if inGame:
		dist = round((charPos.x - startPos.x) / 100)
		ticks += delta
		if ticks >= 1:
			tick()
			ticks = 0
	if objsOnScreen <= 1:
		objsOnScreen = 1
		
	
func tick():
	time += 1
	ptime += 1

func switch_char(char_):
	player.queue_free()
	curr_char = char_
	player = curr_char[0].instance()
	add_child(player)
	player.position = Vector2(2559.17, 84.677)

func saveGame():
	var dir = Directory.new()
	var saveFile = File.new()
	saveFile.open("user://candy.kitty", File.WRITE)
	var unlocks:String
	for i in len(characters):
		unlocks += str(characters[i][1]) +","
	var save_data = {
		"max_time":max_time,
		"max_candy":max_candy,
		"max_dist":max_dist,
		"snakes_killed":snakes_killed,
		"unlocks":unlocks
	}
	for i in save_data.keys():
		saveFile.store_line(i + " " + str(save_data[i]))
	saveFile.close()
	if saveFile.file_exists("user://candy.kitty"):
		print("file saved\n" + str(save_data))

func loadGame():
	var loadFile = File.new()
	if loadFile.file_exists("user://candy.kitty"):
		loadFile.open("user://candy.kitty", File.READ)
		while not loadFile.eof_reached():
			var curr_line = loadFile.get_line()
			var split = curr_line.split(" ")
			if not split[0] == "":
				if split[0] == "unlocks":
					var unlocks = split[1].split(",")
					for i in len(unlocks):
						if unlocks[i] == "True":
							characters[i][1] = true
						if unlocks[i] == "False":
							characters[i][1] = false
		
				else:
					set(split[0], int(split[1]))
		print("file loaded")

func endGame():
	if time > max_time:
		max_time = time
		time = 0
	if candy > max_candy:
		max_candy = candy
		candy = 0
	if dist > max_dist:
		max_dist = dist
		dist = 0
	checkUnlock()
	
	saveGame()
	time = 0

func checkUnlock():
	#checks if characters are unlocked
	#Doge
	if max_candy >= 100 and not characters[1][1]:
		characters[1][1] = true
		#play unlock animation
	#Paddles
	if snakes_killed >= 50 and not characters[2][1]:
		characters[2][1] = true
		#play unlock animation
	#Cheeky
	if max_dist >= 1000 and not characters[3][1]:
		characters[3][1] = true
		#play unlock animation
	#Peeps
	if max_time >= 100 and not characters[4][1]:
		characters[4][1] = true
		#play unlock animation
		
