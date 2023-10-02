extends CharacterBody3D

var mouse_sense: float = 0.2
@export var walk_speed: int = 4
@export var run_speed: int = 6
@export var sneak_speed: int = 2
@export var current_speed: int = 4
@export var jump_velocity: int  = 3
@export var direction: Vector3 = Vector3(1,0,1)

@onready var neck_pivot = $NeckPivot
@onready var kinematic_controller_fsm = $KinematicControllerFSM
@onready var stand_collision = $stand_collision
@onready var sneak_collision = $sneak_collision
@onready var ceilling_raycast = $CeillingRaycast

signal jump

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
		
#	player-related whatevers that don't require InputControllerFSM to be in a specific state, 
#	can't be in kinematic ground state or something because that isn't reserved for player
#	if you're looking for the other half of the strafing code or something look in
#	controller_move_state.gd dumbass [im sorry i shouldn't have said that i know this is messy]
	
	move_and_slide()
	
	if kinematic_controller_fsm.current_state is KinematicGroundState:
		print(neck_pivot.rotation)
		if  !Input.is_action_pressed("strafe"): # bad no good
			neck_pivot.rotation.z = lerp(neck_pivot.rotation.z,0.0,20*delta)
		if Input.is_action_pressed('sneak'):
			current_speed = sneak_speed
			neck_pivot.position.y = lerp(neck_pivot.position.y,1.0,delta*3)
			sneak_collision.disabled = false
			stand_collision.disabled = true
		elif !ceilling_raycast.is_colliding():
			sneak_collision.disabled = true
			stand_collision.disabled = false
			neck_pivot.position.y = lerp(neck_pivot.position.y,1.5,delta*3)
		
		if Input.is_action_just_pressed("jump"): 
			jump.emit()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sense))
		neck_pivot.rotate_x(deg_to_rad(-event.relative.y*mouse_sense))
		neck_pivot.rotation.y = 0
		neck_pivot.rotation.x = clamp(neck_pivot.rotation.x,(deg_to_rad(-85)),(deg_to_rad(85)))
