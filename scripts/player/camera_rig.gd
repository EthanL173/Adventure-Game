extends Node3D

@onready var foreground_camera = $base_camera/foreground_viewport_container/foreground_subviewport/foreground_camera
@onready var background_camera = $base_camera/background_viewport_container/background_subviewport/background_camera
@onready var base_camera = $base_camera

var ray_origin = Vector3()
var ray_target = Vector3()

func _input(event):
	if event.is_action_pressed("right_click"):
		GameManager.is_aiming = true
	elif event.is_action_released("right_click"):
		GameManager.is_aiming = false



func _physics_process(delta):
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = background_camera.project_ray_origin(mouse_pos)
	var to = from + background_camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if not raycast_result.is_empty():

		var pos = raycast_result.position
		var look_at_me = Vector3(pos.x, GameManager.player.position.y, pos.z)
		
		if GameManager.is_aiming == true:
			GameManager.player.is_looking = false
			GameManager.player.visuals.look_at(look_at_me, Vector3.UP) 
			
		elif GameManager.player.velocity == Vector3.ZERO and GameManager.player.is_looking:
			GameManager.player.visuals.look_at(look_at_me, Vector3.UP)
			
		else:
			GameManager.is_aiming = false
		 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_camera.global_transform = GameManager.camera_pos.global_transform
	foreground_camera.global_transform = GameManager.camera_pos.global_transform
