extends CharacterBody3D
class_name MovementController

signal health_effect1
@warning_ignore("unused_signal")
signal health_effect2
@warning_ignore("unused_signal")
signal health_effect3

@export var gravity_multiplier := 3.0
@export var speed := 10
@export var acceleration := 8
@export var deceleration := 10
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10

@onready var MAIN = get_tree().get_nodes_in_group("primenode")[0]
@onready var LVL = get_tree().get_nodes_in_group("level")[0]
@onready var head = $Head
@onready var dmg_timer = $Hurt
@onready var heal_timer = $Heal
@onready var lensbreak = $Head/Camera3D/HartSight/HartSight/BrokenFX
@onready var health := 100
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity")*gravity_multiplier)

var is_dead: bool = false
var direction := Vector3()
var input_axis := Vector2()
var is_sprinting: bool = false

func _ready():
	health_effect1.connect(LVL.visualfx)

func _input(_event):
	if Input.is_action_just_pressed("shift"):
		if is_sprinting:
			is_sprinting = false
		elif !is_sprinting:
			is_sprinting = true
	if Input.is_action_just_pressed("Kill"):
		#kill_player()
		spawn_FX()

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
	if is_dead:
		return
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

func hurt_player():
	health = health - 5
	print(health)
	print("this hurts you, dont it!")
	if health == 80:
		emit_signal("health_effect1")
	elif health == 40:
		emit_signal("health_effect2")
	elif health == 20:
		emit_signal("health_effect3")

func health_restore():
	if health >= 100:
		heal_timer.stop()
		print("back to full health")
	else:
		health = health + 2
		print(health)
		print("recovering health")

func kill_player():
	health = 0
	is_dead = true

func spawn_FX():
	lensbreak.emitting = true
