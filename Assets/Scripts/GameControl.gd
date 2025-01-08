extends Node3D

@warning_ignore("unused_signal")
signal enter_bldg
@warning_ignore("unused_signal")
signal exit_bldg
@onready var primenode = get_tree().get_nodes_in_group("primenode")[0]
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var anim_player = primenode.get_node("Control/fade/anim")
@onready var int_warp = $HOUSES/PlayerHouseInt/WarpSpotInt
@onready var ext_warp = $HOUSES/HousesExt/playerhouse/WarpSpotExt

func _ready():
	Pause.in_game = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	anim_player.play("longfade")
	pass
	
func _input(_event):
	pass
	
func player_home(interior: int): #for the player house 
	anim_player.play_backwards("fade")
	match interior:
		0: #enter
			emit_signal("enter_bldg")
			await get_tree().create_timer(1.05).timeout
			player.global_transform = int_warp.global_transform
		1: #exit
			emit_signal("exit_bldg")
			await get_tree().create_timer(1.05).timeout
			player.global_transform = ext_warp.global_transform
	anim_player.play("fade")
