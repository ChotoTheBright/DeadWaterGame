extends Node3D
#This script is for keeping track of the warp nodes used throughout 
#the town. Swappable via code when calling the door_transit func.
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var MAIN = get_tree().get_nodes_in_group("primenode")[0]
@onready var animplayer = MAIN.get_node("Control/fade/anim")
@onready var game_control = get_parent()

#---#
#---#
@onready var house1 = $HousesExt/House1/warpspot
@onready var house2 = $HousesExt/House2/warpspot
@onready var house3 = $HousesExt/House3/warpspot
@onready var house4 = $HousesExt/House4/warpspot
@onready var house5 = $HousesExt/House5/warpspot
@onready var house6 = $HousesExt/House6/warpspot
#---#
@onready var house7 = $HousesExt/House7/warpspot
@onready var house8 = $HousesExt/House8/warpspot
@onready var house9 = $HousesExt/House9/warpspot
@onready var house10 = $HousesExt/House10/warpspot
@onready var house11 = $HousesExt/House11/warpspot
@onready var house12 = $HousesExt/House12/warpspot
#---#
@onready var house13 = $HousesExt/House13/warpspot
@onready var house14 = $HousesExt/House14/warpspot
@onready var house15 = $HousesExt/House15/warpspot
@onready var house16 = $HousesExt/House16/warpspot
@onready var house17 = $HousesExt/House17/warpspot
#---#
@onready var house18 = $HousesExt/House18/warpspot
@onready var house19 = $HousesExt/House19/warpspot
@onready var house20 = $HousesExt/House20/warpspot
@onready var house21 = $HousesExt/House21/warpspot
#-----------------------#
#----NPC Houses----#
#-----------------------#
@onready var NPChouse1 = $STYLE1/NPCHouseInt1/warpspot #
@onready var NPChouse2 = $STYLE1/NPCHouseInt2/warpspot
@onready var NPChouse3 = $STYLE1/NPCHouseInt3/warpspot
@onready var NPChouse4 = $STYLE1/NPCHouseInt4/warpspot
@onready var NPChouse5 = $STYLE1/NPCHouseInt5/warpspot
@onready var NPChouse6 = $STYLE1/NPCHouseInt6/warpspot
#---#
@onready var NPChouse7 = $STYLE2/NPCHouseInt1/warpspot
@onready var NPChouse8 = $STYLE2/NPCHouseInt2/warpspot
@onready var NPChouse9 = $STYLE2/NPCHouseInt3/warpspot
@onready var NPChouse10 = $STYLE2/NPCHouseInt4/warpspot
@onready var NPChouse11 = $STYLE2/NPCHouseInt5/warpspot
@onready var NPChouse12 = $STYLE2/NPCHouseInt6/warpspot
#---#
@onready var NPChouse13 = $STYLE3/NPCHouseInt1/warpspot
@onready var NPChouse14 = $STYLE3/NPCHouseInt2/warpspot
@onready var NPChouse15 = $STYLE3/NPCHouseInt3/warpspot
@onready var NPChouse16 = $STYLE3/NPCHouseInt4/warpspot
@onready var NPChouse17 = $STYLE3/NPCHouseInt5/warpspot
#---#
@onready var NPChouse18 = $STYLE4/NPCHouseInt1/warpspot
@onready var NPChouse19 = $STYLE4/NPCHouseInt2/warpspot
@onready var NPChouse20 = $STYLE4/NPCHouseInt3/warpspot
@onready var NPChouse21 = $STYLE4/NPCHouseInt4/warpspot
#-----------------------#

func door_transit(house: int, enter: bool):
	animplayer.play_backwards("fade")
	await get_tree().create_timer(1.05).timeout
	match house:
		0:
			if enter:
				player.set_global_transform(NPChouse1.global_transform)
			else:
				player.set_global_transform(house1.global_transform)
		1: 
			if enter:
				player.set_global_transform(NPChouse2.global_transform)
			else:
				player.set_global_transform(house2.global_transform)
		2:
			if enter:
				player.set_global_transform(NPChouse3.global_transform)
			else:
				player.set_global_transform(house3.global_transform)
		3:
			if enter:
				player.set_global_transform(NPChouse4.global_transform)
			else:
				player.set_global_transform(house4.global_transform)
		4:
			if enter:
				player.set_global_transform(NPChouse5.global_transform)
			else:
				player.set_global_transform(house5.global_transform)
		5:#----------------------------------------------------------------------#
			if enter:
				player.set_global_transform(NPChouse6.global_transform)
			else:
				player.set_global_transform(house6.global_transform)
		6:
			if enter:
				player.set_global_transform(NPChouse7.global_transform)
			else:
				player.set_global_transform(house7.global_transform)
		7: 
			if enter:
				player.set_global_transform(NPChouse8.global_transform)
			else:
				player.set_global_transform(house8.global_transform)
		8:
			if enter:
				player.set_global_transform(NPChouse9.global_transform)
			else:
				player.set_global_transform(house9.global_transform)
		9:
			if enter:
				player.set_global_transform(NPChouse10.global_transform)
			else:
				player.set_global_transform(house10.global_transform)
		10:
			if enter:
				player.set_global_transform(NPChouse11.global_transform)
			else:
				player.set_global_transform(house11.global_transform)
		11:
			if enter:
				player.set_global_transform(NPChouse12.global_transform)
			else:
				player.set_global_transform(house12.global_transform)
		12:
			if enter:
				player.set_global_transform(NPChouse13.global_transform)
			else:
				player.set_global_transform(house13.global_transform)
		13:
			if enter:
				player.set_global_transform(NPChouse14.global_transform)
			else:
				player.set_global_transform(house14.global_transform)
		14:
			if enter:
				player.set_global_transform(NPChouse15.global_transform)
			else:
				player.set_global_transform(house15.global_transform)
		15:
			if enter:
				player.set_global_transform(NPChouse16.global_transform)
			else:
				player.set_global_transform(house16.global_transform)
		16:
			if enter:
				player.set_global_transform(NPChouse17.global_transform)
			else:
				player.set_global_transform(house17.global_transform)
		17:
			if enter:
				player.set_global_transform(NPChouse18.global_transform)
			else:
				player.set_global_transform(house18.global_transform)
		18:
			if enter:
				player.set_global_transform(NPChouse19.global_transform)
			else:
				player.set_global_transform(house19.global_transform)
		19:
			if enter:
				player.set_global_transform(NPChouse20.global_transform)
			else:
				player.set_global_transform(house20.global_transform)
		20:
			if enter:
				player.set_global_transform(NPChouse21.global_transform)
			else:
				player.set_global_transform(house21.global_transform)
	animplayer.play("fade")
##--------------------------------#
