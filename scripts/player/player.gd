extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var anime = $visuals/player/AnimationPlayer
@onready var visuals = $visuals
@onready var anime_tree = $visuals/player/AnimationTree


var is_walking = false

var is_looking

var ray_range = 2000.0

func _input(event):
	if event is InputEventMouseMotion:
		is_looking = true
		
	#if event.is_action_pressed("left_click"):
		#shoot()


func _ready():
	anime_tree.active = true
	GameManager.set_player(self)
	anime.set_blend_time("idle", "walk", 0.2)
	anime.set_blend_time("walk", "idle", 0.2)
	
	
func _process(delta):
	anime_parameters()
	
func _physics_process(delta):
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		is_looking = false
		visuals.look_at(direction + position)
		
			
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
			
			
	move_and_slide()
	
	
#func shoot():
	#for n in 10:
		#ray_pos.target_position.x = randf_range(-50, 50)
		#if ray_pos.is_colliding():
			#print("Hit ")
		#elif !ray_pos.is_colliding():
			#print("No Hit")
		#print(ray_pos.target_position.x)
	#ray_pos.target_position.x = 0.0
	
func anime_parameters():
	if(velocity == Vector3.ZERO):
		if GameManager.is_aiming == true:
			anime_tree["parameters/conditions/aim_move"] = false
			anime_tree["parameters/conditions/is_walking"] = false
			anime_tree["parameters/conditions/is_aiming"] = true
			anime_tree["parameters/conditions/aim_idle"] = true
			anime_tree["parameters/conditions/idle"] = false
			anime_tree["parameters/conditions/walk_Waim"] = false
		else:
			anime_tree["parameters/conditions/aim_move"] = false
			anime_tree["parameters/conditions/idle"] = true
			anime_tree["parameters/conditions/aim_idle"] = false
			anime_tree["parameters/conditions/is_walking"] = false
			anime_tree["parameters/conditions/is_aiming"] = false
			anime_tree["parameters/conditions/walk_Waim"] = false
	else:
		if GameManager.is_aiming == true:
			anime_tree["parameters/conditions/walk_Waim"] = true
			anime_tree["parameters/conditions/aim_move"] = true
			anime_tree["parameters/conditions/aim_idle"] = false
			anime_tree["parameters/conditions/is_aiming"] = false
			anime_tree["parameters/conditions/idle"] = false
			anime_tree["parameters/conditions/is_walking"] = false
		else:
			anime_tree["parameters/conditions/aim_move"] = false
			anime_tree["parameters/conditions/is_aiming"] = false
			anime_tree["parameters/conditions/idle"] = false
			anime_tree["parameters/conditions/aim_idle"] = false
			anime_tree["parameters/conditions/is_walking"] = true
			anime_tree["parameters/conditions/walk_Waim"] = false
