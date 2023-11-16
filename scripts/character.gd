extends CharacterBody3D

signal died

const SPEED = 5.0
const JUMP_VELOCITY = 9
@export var weight: float = 20
@export_range(0, 100) var stamina: float = 100
var last_vel: Vector3
var direction: Vector3

# shader controls
@export var sprite_sheet_path: Texture
@export var frame_offsets: Array
var anim_frame: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	%MeshInstance3D.get_active_material(0).set_shader_parameter("albedo_texture", sprite_sheet_path)
	var mat_override = %MeshInstance3D.get_active_material(0).duplicate()
	%MeshInstance3D.mesh.material = mat_override

func _process(delta):
	if stamina <= 0:
		emit_signal("died")
	if stamina >= 33 and stamina < 100:
		stamina += .1
	var last_vel = velocity
	if position.y <= -15:
			got_hit(100, position)
#	%MeshInstance3D.get_active_material(0).set_shader_parameter("stamina_state", stamina*.01)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
func jump():
	# Handle Jump.
	if is_on_floor() and stamina > weight:
		stamina -= weight
		velocity.y = JUMP_VELOCITY

func jump_rel():
	if !is_on_floor():
		velocity.y += -weight*.5

func move(input_dir):
	if stamina <= 0:
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		stamina -= .001
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func got_hit(damage, pos):
	stamina -= damage
	move(Vector2((pos.x - position.x)*100, 0))
	velocity.y = JUMP_VELOCITY*.75
	%AnimationPlayer.play("got_hit")

func check_cols(body):
	if body.name == "hazard":
		got_hit(30, body.position)
	if body.name == "candy":
		print("got candy")
		stamina += body.value
		body.collect()
