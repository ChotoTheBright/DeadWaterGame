extends StaticBody3D

@warning_ignore("unused_signal")
signal door_interact
@warning_ignore("unused_signal")
signal door_interact2

var door_type: int = 0

func _Interact():
	emit_signal("door_interact")
	emit_signal("door_interact2")
