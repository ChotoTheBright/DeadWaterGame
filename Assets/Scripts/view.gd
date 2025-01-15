extends Node3D

@onready var player = get_parent()
@onready var view_item = $Camera3D/HartSight
@onready var camera = $Camera3D
@onready var FX1 = $Camera3D/HartSight/FX1
@onready var vp_sprite: Sprite3D = $Camera3D/HartSight/Sprite3D
@onready var lens_timer = $Camera3D/HartSight/HartSight/Timer
@onready var lens = $Camera3D/HartSight/HartSight/LensMagic#magic one
@onready var lens_blue = $Camera3D/HartSight/HartSight/Lens#normal one
@onready var camera_player: Camera3D = get_viewport().get_camera_3d()
@onready var viewport: SubViewport = get_node("Camera3D/HartSight/SubViewport")
@onready var vp_camera: Camera3D = viewport.get_node("Camera3D")
@export var cam_up: bool = false#true

var hurt_player: bool = false
var cam_zoom: bool = false
var bobtimes = [0,0,0]
var Q_bobtime : float = 0.0
var Q_bob : float = 0.0
var bobRight : float = 0.0
var bobForward : float = 0.0
var bobUp : float = 0.0
var idleRight : float = 0.0
var idleForward : float = 0.0
var idleUp : float =  0.0
var mouse_move : Vector2 = Vector2.ZERO
var viewmodel_origin = Vector3(0.25, -0.4, -0.5)
#^ set this to the gun models local position
var swayPos : Vector3 = Vector3.ZERO
var swayPos_offset : float = 0.06               # default: 0.12
var swayPos_max : float = 0.5                   # default: 0.1
var swayPos_speed : float = 1.50                 # default: 9.0
var swayRot : Vector3 = Vector3.ZERO
var swayRot_angle : float = 2.50                 # default: 5.0   (old: Vector3(5.0, 5.0, 2.0))
var swayRot_max : float = 4.50                  # default: 15.0  (old: Vector3(12.0, 12.0, 4.0))
var swayRot_speed : float = 2.50                 # default: 10.0
var deltaTime : float = 0.0
#Bob
var cl_bob : float = 0.01             # default: 0.01
var cl_bobup : float = 0.5            # default: 0.5
var cl_bobcycle : float = 1.0#.8         # default: 0.8
var ql_bob : float = 0.012            # default: 0.012
var ql_bobup : float = 0.5            # default: 0.5
var ql_bobcycle : float = 1.0#.6         # default: 0.6
#Roll
var rollangles : float = 2.0          # default: 15.0 // was og at 2
var rollspeed : float = 200.0         # default: 300.0
var tiltextra : float = 2.0           # default: 2.0
#Skibidi
var mouse_sensitivity : float = 0.1 #0.1
var mouse_rotation_x : float = 0.0
var newbob : bool = false
var oldy : float = 0.0
#View Idle
var idlescale : float= 1.6            # default: 1.6
var iyaw_cycle : float = 1.5          # default: 1.5
var iroll_cycle : float = 1.0         # default: 1.0
var ipitch_cycle : float = 2.0        # default: 2.0
var iyaw_level : float = 0.1          # default: 0.1
var iroll_level : float = 0.2         # default: 0.2
var ipitch_level : float = 0.15       # default: 0.15
var idlePos_scale = 0.1                         # default: 0.1
var idlePos_cycle = Vector3(2.0, 4.0, 0)        # default: Vector3(2.0, 4.0, 0) 
var idlePos_level = Vector3(0.02, 0.045, 0)     # default: Vector3(0.02, 0.045, 0) 
var idleRot_scale = 0.5                         # default: 0.5
var idleRot_cycle = Vector3(1.0, 0.5, 1.25)     # default: Vector3(1.0, 0.5, 1.25)
var idleRot_level = Vector3(-1.5, 2, 1.5)       # default: Vector3(-1.5, 2, 1.5)
var idletime : float = 0.0
var y_offset : float = 1.25           # default: 1.0

enum { VB_COS, VB_SIN, VB_COS2, VB_SIN2 }
const bob_mode = VB_SIN

func _ready():
	newbob = false#true
	@warning_ignore("int_as_enum_without_cast")
	viewport.set_update_mode(0)
	vp_sprite.visible = false
	if cam_up == false:
		viewmodel_origin = Vector3(0.0,-1.5,0.0)
	FX1.emitting = true

func _physics_process(delta):
	if player.is_dead: #
		camera.rotation_degrees.z = 80
		transform.origin = Vector3(0.0, -1.6, 0.0)
		return
	
	deltaTime = delta

	vp_camera.global_transform = camera_player.global_transform
	view_item.transform.origin = viewmodel_origin
	view_item.rotation_degrees = Vector3.ZERO
	view_model_sway()
	camera.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	transform.origin = Vector3(0, y_offset, 0)
	velocity_roll()

	if player.velocity.length() <= 0.1:
		bobtimes = [0,0,0]
		Q_bobtime = 0.0
		add_idle()
		view_idle()
		view_model_idle()
	else:
		idletime = 0.0
		add_bob()
		if newbob:
			view_bob_modern()
		else:
			view_bob_classic()
		view_model_bob()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = event.relative * 0.1
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -90, 90)
		player.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

	if Input.is_action_just_pressed("cam_view") and lens_timer.is_stopped():
		item_close_view()

	if Input.is_action_just_pressed("raise_cam"):
		item_raise()

func view_model_idle():
	for i in range(3):
		view_item.transform.origin[i] += idlePos_scale * sin(idletime * idlePos_cycle[i]) * idlePos_level[i]
		view_item.rotation_degrees[i] += idleRot_scale * sin(idletime * idleRot_cycle[i]) * idleRot_level[i]

func add_idle():
	idletime += deltaTime
	idleRight = idlescale * sin(idletime * ipitch_cycle) * ipitch_level
	idleUp = idlescale * sin(idletime * iyaw_cycle) * iyaw_level
	idleForward = idlescale * sin(idletime * iroll_cycle) * iroll_level

func view_idle():
	camera.rotation_degrees.x += idleUp
	camera.rotation_degrees.y += idleRight
	camera.rotation_degrees.z += idleForward

func add_bob():
	bobRight = calc_bob(0.75, bob_mode, 0, bobRight)
	bobUp = calc_bob(1.50, bob_mode, 1, bobUp)
	bobForward = calc_bob(1.00, bob_mode, 2, bobForward)

func view_bob_modern():
	camera.rotation_degrees.z += bobRight * 0.8
	camera.rotation_degrees.y -= bobUp * 0.8
	camera.rotation_degrees.x += bobRight * 1.2

func view_bob_classic():
	transform.origin[1] += calc_bob_classic()

func calc_bob_classic():
	var vel : Vector3
	var cycle : float
	
	Q_bobtime += deltaTime
	cycle = Q_bobtime - int(Q_bobtime / ql_bobcycle) * ql_bobcycle
	cycle /= ql_bobcycle
	if cycle < ql_bobup:
		cycle = PI * cycle / ql_bobup
	else:
		cycle = PI + PI * (cycle - ql_bobup) / (1.0 - ql_bobup)
	
	vel = player.velocity
	Q_bob = sqrt(vel[0] * vel[0] + vel[2] * vel[2]) * ql_bob
	Q_bob = Q_bob * 0.3 + Q_bob * 0.35 * sin(cycle)
	Q_bob = clamp(Q_bob, -7.0, 4.0)
	
	return Q_bob

func calc_bob (freqmod : float, mode, bob_i : int, bob : float):
	var cycle : float
	var vel : Vector3
	
	bobtimes[bob_i] += deltaTime * freqmod
	cycle = bobtimes[bob_i] - int( bobtimes[bob_i] / cl_bobcycle ) * cl_bobcycle
	cycle /= cl_bobcycle
	
	if cycle < cl_bobup:
		cycle = PI * cycle / cl_bobup
	else:
		cycle = PI + PI * ( cycle - cl_bobup)/( 1.0 - cl_bobup)
	
	vel = player.velocity
	bob = sqrt(vel[0] * vel[0] + vel[2] * vel[2]) * cl_bob
	
	if mode == VB_SIN:
		bob = bob * 0.3 + bob * 0.7 * sin(cycle)
	elif mode == VB_COS:
		bob = bob * 0.3 + bob * 0.7 * cos(cycle)
	elif mode == VB_SIN2:
		bob = bob * 0.3 + bob * 0.7 * sin(cycle) * sin(cycle)
	elif mode == VB_COS2:
		bob = bob * 0.3 + bob * 0.7 * cos(cycle) * cos(cycle)
	bob = clamp(bob, -7, 4)
	
	return bob

func view_model_sway():
	var pos : Vector3
	var rot : Vector3

	if mouse_move == null:
		mouse_move = mouse_move.lerp(Vector2.ZERO, 1 * deltaTime)
		return

	pos = Vector3.ZERO
	pos.x = clamp(-mouse_move.x * swayPos_offset, -swayPos_max, swayPos_max)
	pos.y = clamp(mouse_move.y * swayPos_offset, -swayPos_max, swayPos_max)
	swayPos = lerp(swayPos, pos, swayPos_speed * deltaTime)
	view_item.transform.origin += swayPos
	
	rot = Vector3.ZERO
	rot.x = clamp(-mouse_move.y * swayRot_angle, -swayRot_max, swayRot_max)
	rot.z = clamp(mouse_move.x * swayRot_angle, -swayRot_max/3, swayRot_max/3)
	rot.y = clamp(-mouse_move.x * swayRot_angle, -swayRot_max, swayRot_max)
	swayRot = lerp(swayRot, rot, swayRot_speed * deltaTime)
	view_item.rotation_degrees += swayRot

func view_model_bob():
	for i in range(3):
		view_item.transform.origin[i] += bobRight * 0.1 * transform.basis.x[i] #0.25
		view_item.transform.origin[i] += bobUp * 0.1 * transform.basis.y[i] # 0.125
		view_item.transform.origin[i] += bobForward * 0.03125 * transform.basis.z[i] #0.06125

func velocity_roll():
	var side : float
	
	side = calc_roll(player.velocity, rollangles, rollspeed) * 4
	camera.rotation_degrees.z += side

func calc_roll (velocity : Vector3, angle : float, speed : float):
	var s : float
	var side : float
	
	side = velocity.dot(-get_global_transform().basis.x)
	s = sign(side)
	side = abs(side)
	
	if (side < speed):
		side = side * angle / speed;
	else:
		side = angle;
	
	return side * s

#lens movement
func item_close_view():
	if cam_up == false:
		return
	var _tween = create_tween()
	if cam_zoom == false:  #NOT ZOOMED#
		lens_timer.start()
		_tween.tween_property(view_item, "position", Vector3(0.0,0.0,-0.3),0.5).from_current()
		viewmodel_origin = Vector3(0.0,0.0,-0.3) #0.1,-0.4,0.0 / alt coords
		cam_zoom = true
		FX1.emitting = true
		lens_blue.visible = false
		lens.visible = true
		await get_tree().create_timer(0.8).timeout #0.9
		player.dmg_timer.start()
		vp_sprite.visible = true
		viewport.set_update_mode(viewport.UPDATE_WHEN_VISIBLE)#2

	elif cam_zoom == true: #ZOOMED IN#
		lens_timer.start()
		_tween.tween_property(view_item, "position", Vector3(0.25, -0.4, -0.5),0.5).from_current()
		viewmodel_origin = Vector3(0.25, -0.4, -0.5)
		cam_zoom = false
		FX1.emitting = true
		lens_blue.visible = true
		lens.visible = false
		await get_tree().create_timer(0.75).timeout #0.9
		player.dmg_timer.stop()
		player.heal_timer.start()
		vp_sprite.visible = false
		viewport.set_update_mode(viewport.UPDATE_DISABLED)#0
 
func item_raise():
	if cam_zoom == true: 
			return
	var _tween = create_tween()
	if cam_up == false: #the lens is down
		_tween.tween_property(view_item, "position", Vector3(0.25, -0.4, -0.5),0.5).from_current()
		viewmodel_origin = Vector3(0.25, -0.4, -0.5)
		cam_up = true
	elif cam_up == true:  #the lens is up
		_tween.tween_property(view_item, "position", Vector3(0.0,-1.0,0.0),0.5).from_current()
		viewmodel_origin = Vector3(0.0,-1.0,0.0)
		cam_up = false
