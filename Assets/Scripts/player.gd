extends CharacterBody3D
class_name MovementController

@export var gravity_multiplier := 3.0
@export var speed := 10
@export var acceleration := 8
@export var deceleration := 10
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
var is_sprinting: bool = false
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

func _input(_event):
	if Input.is_action_just_pressed("shift"):
		if is_sprinting:
			is_sprinting = false
		elif !is_sprinting:
			is_sprinting = true

# Called every physics tick. 'delta' is constant
func _physics_process(delta):
	input_axis = Input.get_vector(&"movement_down", &"movement_up",
			&"movement_left", &"movement_right")
	
	direction_input()
	
	if is_on_floor():
		if Input.is_action_just_pressed(&"movement_jump"):
			velocity.y = jump_height
	else:
		velocity.y -= gravity * delta
	
	if is_on_floor():
		if is_sprinting:
			speed = 20
		else:
			speed = 10
	accelerate(delta)
	
	move_and_slide()

func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y

func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	var accel_weight = clamp(temp_accel * delta, 0.0, 1.0)
	temp_vel = temp_vel.lerp(target, accel_weight)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
