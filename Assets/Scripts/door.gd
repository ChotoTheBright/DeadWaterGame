extends Node3D
@warning_ignore("unused_signal")
signal door_interact

func _Interact() -> void:
	emit_signal("door_interact")
