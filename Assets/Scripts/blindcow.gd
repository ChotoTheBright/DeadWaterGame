extends CharacterBody3D
@onready var anim_player = $BlindMooMoo/Armature/AnimationPlayer

func _ready():
	anim_player.play("eating2")
