extends RayCast3D

@onready var usetimer = $Timer
@onready var orange = $Range #"O" range
@export var limitobj = 150
@export var throw_force = 50
var Target = null
var can_use = true
var text_visible = false
var object_grabbed = null

func _ready():
	pass

func _physics_process(_delta):
	Target = get_collider()
	
	if object_grabbed:
		var vector = orange.global_transform.origin - object_grabbed.global_transform.origin
		object_grabbed.linear_velocity = vector * 6
		object_grabbed.axis_lock_angular_x = true
		object_grabbed.axis_lock_angular_y = true
		object_grabbed.axis_lock_angular_z = true
		
		if vector.length() >= 4:
			print("fallin out the hands")
			object_release()
	
	if Input.is_action_just_pressed("interact"):
		if can_use:
			can_use = false
			if get_collider() and usetimer.is_stopped() and Target.is_in_group("Useable"):
				Target._Interact()#prompt("Use")
				usetimer.start()
			elif not object_grabbed:
				if get_collider() is RigidBody3D and usetimer.is_stopped() and Target.mass <= limitobj:
					object_grabbed = Target
					object_grabbed.rotation_degrees.x = 0
					object_grabbed.rotation_degrees.z = 0
			else:
				object_release()
				print("nothing there to check out")
	else:
		can_use = true
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if object_grabbed: 
				if object_grabbed.has_method("thrown"):
					object_grabbed.thrown()
				object_grabbed.linear_velocity = global_transform.basis.z * -throw_force
				object_release()
	
func object_release():
	object_grabbed.axis_lock_angular_x = false
	object_grabbed.axis_lock_angular_y = false
	object_grabbed.axis_lock_angular_z = false
	object_grabbed = null
	usetimer.start()
	pass
