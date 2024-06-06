extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var anime = $visuals/player/AnimationPlayer
@onready var visuals = $visuals
@onready var anime_tree = $visuals/player/AnimationTree

var is_walking = false


func _ready():
	anime_tree.active = true
	GameManager.set_player(self)
	anime.set_blend_time("idle", "walk", 0.2)
	anime.set_blend_time("walk", "idle", 0.2)
	
func _process(delta):
	anime_parameters()
	
func _physics_process(delta):
	
	#print("walking: ", is_walking)
	#print("aiming: ", GameManager.is_aiming)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		visuals.look_at(direction + position)
		
		#if !is_walking:
			#is_walking = true
			#print("first if")
			#anime.play("walk")
			
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#if is_walking:
			#is_walking = false
			#print("second if")
			#anime.play("idle")
			
			
	move_and_slide()
	
	
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
