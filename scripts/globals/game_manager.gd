extends Node

var player:Node

var camera_pos:Node

var is_aiming = false

func set_player(player_node):
	player = player_node
	
func set_camera_pos(camera_pos_node):
	camera_pos = camera_pos_node
