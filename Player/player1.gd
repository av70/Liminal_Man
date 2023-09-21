extends CharacterBody3D

# to do : sometimes you are unable to jump when you should while descending 
# staircases

@onready var player = $"."
@onready var neck_pivot = $NeckPivot
@onready var camera = $NeckPivot/Camera

@onready var tip_toe_collision = $tip_toe_collision
@onready var standing_collision = $standing_collision
@onready var floor_raycast = $FloorRaycast
@onready var audio_queue = $NeckPivot/AudioQueue


@onready var head_raycast = $HeadRaycast

@export var current_speed: float = 5.0
@export var move_lerp_speed: int = 10
@export var char_state: int = 6

# [0 = idle, 1 = walk, 2 = sneak, 3 = run, 4 = jump, 5 = lunge, 6 = fall]

var mouse_sense: float = 0.4
var direction: Vector3 = Vector3.ZERO
var grounded: bool = false

const walk_speed: int = 5
const run_speed: int = 7
const tip_toe_speed: int = 3
const lunge_speed: int = 10
const jump_velocity: int  = 5
var tip_toe_depth: float = -0.4 # amount the camera lowers relative to regular

# ~[ LE EPIC MOVEMENT SCHEME ]~

	# {w, a, s, d} -> move [duh]

	# spacebar-> jump [duuurh]
		#[normal hitbox, no extra forward velocity, 1.25x upward velocity than normal jump]
	
	# move + shift -> run 

	# c -> tip toe
		# [hitbox shortened, slow speed]

	# shift + spacebar -> lunge
		# [shortened hitbox, extra forward velocity, .8x upward velocity than normal jump]

	# [secret four digit code] -> zumbo sauce mode

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sense))
		neck_pivot.rotate_x(deg_to_rad(-event.relative.y*mouse_sense))
		neck_pivot.rotation.x = clamp(neck_pivot.rotation.x,(deg_to_rad(-89)),(deg_to_rad(89)))

func check_state() -> int:
	if grounded: # [ground]
		if velocity.x+velocity.z >= 0.4 or velocity.x+velocity.z <= -0.4:
			if current_speed >= lunge_speed:
				print('run')
				return 2 # run
			elif current_speed >= walk_speed:
				print('walk')
				return 1 # walk
		else: 
			print('idle')
			return 0 # idle
			
	if velocity.y < -1: # [air]
		if current_speed >= run_speed:
			print('jump')
			return 4 # jump
		elif current_speed >= lunge_speed:
			print('lunge')
			return 5 # lunge
	else:
		print('fall')
		return 6 # fall
	return 0 # zumbo sauce mode !

func set_speed(speed: float) -> void:
	current_speed = lerp(current_speed,speed,0.5)

func set_state() -> void:
	var new_state = check_state()
	if char_state != check_state(): 
		if new_state > 0 and new_state < 4:
			pass
		if new_state >= 3 and char_state <= 4:
			print('no footstep')
		elif new_state < 4 and char_state > 3:
			if floor_raycast.is_colliding():
				audio_queue.play_audio()
		print(new_state,char_state)
		char_state = check_state()
		

func crouch(boolean: bool,delta) -> void:
	if boolean:
		neck_pivot.position.y = lerp(neck_pivot.position.y,1.2+tip_toe_depth,delta*.4*move_lerp_speed)
		tip_toe_collision.disabled = false
		standing_collision.disabled = true
	elif !head_raycast.is_colliding():
		neck_pivot.position.y = lerp(neck_pivot.position.y,1+-tip_toe_depth,delta*.4*move_lerp_speed)
		tip_toe_collision.disabled = true
		standing_collision.disabled = false


func _physics_process(delta):
	if not grounded:
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_front", "move_back")
	
	direction = lerp(direction,(
		transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
		delta*move_lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if Input.is_action_pressed("sneak"):
		crouch(true,delta)
		if grounded:
			set_speed(tip_toe_speed)
	
	elif Input.is_action_pressed("run"): # tip toeing takes priority
		if grounded:
			set_speed(run_speed)
			crouch(false,delta)
		elif velocity.y >= 1:
			set_speed(lunge_speed)
			crouch(true,delta)
		
	elif grounded:
		set_speed(walk_speed)
		crouch(false,delta)
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"): 
		if is_on_floor() or grounded:
			if Input.is_action_pressed("run"):
				velocity.y = jump_velocity*.8
			else:
				velocity.y = jump_velocity
	
	if floor_raycast.is_colliding(): # how player y value is treated
		var floor_target: Vector3 = floor_raycast.get_collision_point()
		if velocity.y < 0:
			velocity.y = -current_speed/2 # prevents phasing through floor
		if velocity.x+velocity.z >= 0.4 or velocity.x+velocity.z <= -0.4:
			# i know this isn't the best solution but i'm too busy doin' yo mom
			position.y  = move_toward(position.y,floor_target.y,current_speed*delta)
		else:
			position.y = floor_target.y
		#i want to murder people
		grounded = true
	else:
		grounded = false
	
	set_state()


	move_and_slide()
