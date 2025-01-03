extends RigidBody3D

@export var can_hurt: bool = false
var is_thrown: bool = false

func thrown():
	if is_thrown == false:
		is_thrown = true
	if can_hurt:
		pass
	pass

func not_thrown():
	is_thrown = true

func _Interact():
	print("this has been interacted with uwu")
