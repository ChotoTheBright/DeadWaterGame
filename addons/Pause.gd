extends Node

@onready var in_game: bool = false
var can_press: bool = true


func _ready():
	#this executes at runtime
	process_mode = PROCESS_MODE_ALWAYS
	
func _input(event):
	if not event.is_action_pressed("ui_cancel"):
		can_press = true
		
	if can_press:
		if event.is_action_pressed("ui_cancel"):
			can_press = false
			if get_tree().paused:
				pass
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if in_game:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if get_tree().paused:
				get_tree().paused = false
