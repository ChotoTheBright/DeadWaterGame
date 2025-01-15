extends Node3D
@onready var anim_play = $AnimationPlayer

func _ready():
	anim_play.play("hearts")
