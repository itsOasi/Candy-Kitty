extends KinematicBody2D

#basic attributes
export var spd:int
export var ap:int
#for jumping multiple times
export var max_jump = 1
var not_on_floor = false

export var idle_frame:int
export var attk_frame:int
export var jump_frame:int
export var fall_frame:int

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
export var hitOk = false
export var gotHitOk = true

var _delta

var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("start", self, "start")
	Globals.connect("attk", self, "attack")
	Globals.connect("jump", self, "jump")
	Globals.connect("jrel", self, "jrel")
	Globals.connect("right", self, "right")
	Globals.connect("left", self, "left")
	jumpInt = max_jump

func _process(delta):
	_delta = delta
	
	#if falling, player can jump again
	#depending on the character
	if vel.y >= 1:
		jumpOk = true
		$tex.frame = fall_frame
	if vel.y <= -1:
		$tex.frame = jump_frame
		not_on_floor = true
	if position.y > 4000:
		Globals.emit_signal("end")
	#if on floor, reset movement on y axis
	if is_on_floor():
		acc.y = 0
		vel.y = 0
		jumpOk = true
		gotHitOk = true
		jumpInt = max_jump
		if not_on_floor:
			$tex.frame = idle_frame
			not_on_floor = false
	else:
		move(0, Globals.grav, delta)
	if jumpInt <= 0:
		jumpOk = false

	move(0, 0, delta)

func left():
	if not flipped:
		scale.x = -1
		flipped = true
	move(-spd, 0, _delta)

func right():
	if flipped:
		scale.x = -1
		flipped = false
	move(spd, 0, _delta)

func jump():
	if jumpOk:
		jumpOk = false
		$jump.play()
		jumpInt -= 1
		move(0, -jump_str * 10, _delta)

func jrel():
	jrel = true

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
	translate(move_and_slide(vel, Vector2.UP))
	Globals.charPos = position
	acc.x += -acc.x * fric

func collect(amnt):
	Globals.candy += amnt

func _on_collect_body_entered(body):
#	print(body.name)
	if body.get('amnt'):
		collect(body.amnt)
		$collect2.playing = true
		body.queue_free()
		jumpOk = true
		
func _on_attk_body_entered(body):
	
	if body.get('anim'):
		body.anim.play()
	if body.get('hp'):
		body.hit(ap)

func _on_bodycol_body_entered(body):
	pass

func gotHit(dir:int):
	if gotHitOk:
		move(spd*1000*dir, -Globals.grav*50, _delta)
		$hit.play()
		gotHitOk = false

func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start(3)


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.stop()

func _on_Timer_timeout():
	Globals.emit_signal("end")
	vel = Vector2(0,0)
	acc = Vector2(0,0)


func start():
	Globals.startPos = position
