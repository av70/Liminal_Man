extends HumanEntity
class_name Player

var mouse_sense: float = 0.1
var mouse_lock: bool = false

var picked_node: RigidBody3D
var hovered_node: RigidBody3D
var rotation_power: float = 0.4

@onready var neck_pivot = $NeckPivot
@onready var kinematic_controller_fsm = $KinematicControllerFSM
@onready var stand_collision = $stand_collision
@onready var sneak_collision = $sneak_collision
@onready var ceilling_raycast = $CeillingRaycast
@onready var interact_ray = $NeckPivot/Camera/InteractRay
@onready var hand = $NeckPivot/Camera/Hand
@onready var joint = $NeckPivot/Camera/Joint
@onready var static_body_3d = $NeckPivot/Camera/StaticBody3D


signal node_hovered(node)
signal node_unhovered(node)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func on_pick_node_hovered():
	hovered_node = interact_ray.get_collider()
	node_hovered.emit(hovered_node)

func on_pick_node_picked():
	if !picked_node and interact_ray.get_collider():
		picked_node = interact_ray.get_collider()
		joint.set_node_b(interact_ray.get_collider().get_path())
	else:
		picked_node = null
		joint.set_node_b(joint.get_path())

func on_pick_node():
	var a = picked_node.global_transform.origin
	var b = hand.global_transform.origin
	picked_node.set_linear_velocity((b-a)*6)
	if Input.is_action_just_pressed('move_hand_away') and hand.position.z >= -3 : hand.position.z -= 0.25
	elif Input.is_action_just_pressed('move_hand_close') and hand.position.z <= -1 : hand.position.z += 0.25

func rotate_pick_node(event):
	if picked_node:
		if event is InputEventMouseMotion:
			static_body_3d.rotate_x(deg_to_rad(event.relative.y*rotation_power))
			static_body_3d.rotate_y(deg_to_rad(event.relative.x*rotation_power))


func _physics_process(delta):
	
#	player-related whatevers that don't require InputControllerFSM to be in a specific state,
#	or rather requires one of many states, which means it's better for it to be here than rewrite it
#	for each state? they can't be in kinematic ground state or something because that isn't reserved
#	for the player. so, if you're looking for the other half of the strafing code or something look in
#	controller_move_state.gd dumbass [im sorry i shouldn't have said that i know this is messy]
	
	move_and_slide()
	
	if kinematic_controller_fsm.current_state is KinematicGroundState:
	# 	i.e player can;t begin picking objects up while in air or in car? to be implemented? no cars?
		
		if  !Input.is_action_pressed("strafe"):
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
			
			if Input.is_action_pressed('run'): current_speed = run_speed
			else: current_speed = walk_speed
		
		if Input.is_action_just_pressed("jump"): jump.emit()
		
		if interact_ray.is_colliding():
			if interact_ray.get_collider() is RigidBody3D:
				if !hovered_node: on_pick_node_hovered()
	
	if picked_node: on_pick_node()

func _input(event):
	if event is InputEventMouseMotion and !mouse_lock:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sense))
		neck_pivot.rotate_x(deg_to_rad(-event.relative.y*mouse_sense))
		neck_pivot.rotation.y = 0
		neck_pivot.rotation.x = clamp(neck_pivot.rotation.x,(deg_to_rad(-85)),(deg_to_rad(85)))
	
	elif Input.is_action_just_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
	if Input.is_action_just_pressed('pick_up'):on_pick_node_picked()
	
	if Input.is_action_pressed('rotate_hand_toggle') and picked_node:
		mouse_lock = true
		rotate_pick_node(event)
	
	if Input.is_action_just_released('rotate_hand_toggle'): mouse_lock = false
