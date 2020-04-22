extends KinematicBody2D

var player

#basic attributes
export var hp:int
export var spd:int
export var ap:int
#for jumping multiple times
export var max_jump = 1

#movement vars
var last_pos:Vector2
var acc = Vector2(0, 0)
var vel = Vector2(0, 0)
export var fric:float

var jumpOk = false
export var jump_str:int
var jumpInt
var jrel = false

export var attackOk = true

var _delta

var flipped = false


# Called when the node enters the scene tree for the first time.
func _ready():
	player = Globals.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_delta = delta
	var dist = abs(Globals.player.position.x - position.x)
	if $Sprite/VisibilityNotifier2D.visible:
		Globals.debug_msg = str(dist)
		if Globals.player.position.x > position.x:
			right()
		if Globals.player.position.x < position.x:
			left()
		if dist < 500 and attackOk:
			attack()

	move(0, Globals.grav, delta)

func left():
	if flipped:
		scale.x = -1
		flipped = false
	move(-spd, 0, _delta)

func right():
	if not flipped:
		scale.x = -1
		flipped = true
	move(spd, 0, _delta)

func jump():
	if jumpOk:
		jumpOk = false
		jumpInt -= 1
		move(0, -jump_str * 10, _delta)

func attack():
	if attackOk:
		attackOk = false
		$AnimationPlayer.play("attack")
		if flipped:
			move(-spd * 20, 0, _delta)
		else:
			move(spd * 20, 0, _delta)

func move(x, y, delta):
	acc.x += x
	acc.y += y
	vel.x = acc.x * spd * delta
	vel.y =  acc.y * delta
	if vel.y >= 20:
		vel.y = 20
	if vel.x >= spd:
		vel.x = spd
	if vel.x <= -spd:
		vel.x = -spd
	translate(Vector2(vel.x, 0))
	acc.x += -acc.x * fric

func _on_VisibilityNotifier2D_screen_entered():
	Globals.objsOnScreen += 1
	
func hit(ap):
	hp -= ap
	print(name + " got hit:" + str(hp))
	$hit.play()

func _on_hit_finished():
	if hp <= 0:
		Globals.objsOnScreen -= 1
		Globals.snakes_killed += 1
		queue_free()



func _on_VisibilityNotifier2D_screen_exited():
		Globals.objsOnScreen -= 1
		queue_free()



func _on_nmy_body_entered(body):
	if body == Globals.player:
		if flipped:
			body.gotHit(1)
		else:
			body.gotHit(-1)
