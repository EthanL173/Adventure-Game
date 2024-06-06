extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_camera_pos(self)
