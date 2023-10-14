extends HumanEntity
class_name Player

var rotation_power: float = 0.4
var move_power: float = 7.0

@export var picked_node: Pickable
@export var hovered_node: PhysicsBody3D
@export var action_index: int = 0

@export var mouse_sense: float = 0.1
@export var mouse_lock: bool = false

#@export var player_inventory: InventoryData
#@export var container_inventory: InventoryData
#@export var equip_inventory: InventoryData

@onready var kinematic_controller_fsm = $KinematicControllerFSM
@onready var stand_collision = $stand_collision
@onready var sneak_collision = $sneak_collision
@onready var ceilling_raycast = $CeillingRaycast

@onready var neck_pivot = $NeckPivot
@onready var interact_ray = $NeckPivot/Camera/InteractRay
@onready var hand = $NeckPivot/Camera/Hand
@onready var joint = $NeckPivot/Camera/Joint
@onready var static_body_3d = $NeckPivot/Camera/StaticBody3D
@onready var cursor = $NeckPivot/Camera/Cursor

#signal toggle_inventory

signal on_pickable_node_hovered
signal on_change_action_index_up
signal on_change_action_index_down

#--------------------------------------------------------------------------------------------------
# rigid body grab/collect/use functions

func on_node_hovered():
	action_index = 0
	cursor.visible = true
	hovered_node = interact_ray.get_collider()
	on_pickable_node_hovered.emit(self)

func on_node_unhovered():
	if !picked_node: cursor.visible = false
	hovered_node = null
	on_pickable_node_hovered.emit(self)

func on_node_picked():
	if interact_ray.get_collider() is Pickable:
		picked_node = interact_ray.get_collider()
		joint.set_node_b(interact_ray.get_collider().get_path())

func on_node_unpicked():
	cursor.visible = false
	picked_node = null
	joint.set_node_b(joint.get_path())

func on_input(index):
	hovered_node.call(hovered_node.actions[index]['Func'])
	if hovered_node.actions[index]['Name'] == 'grab':
		if !picked_node: on_node_picked()
		else: on_node_unpicked()

# called every frame while picking or hovering if not being picked

func on_hover_node():
	cursor.global_position = hovered_node.global_position

func on_pick_node():
	var a = picked_node.global_transform.origin
	var b = hand.global_transform.origin
	picked_node.set_linear_velocity((b-a)*move_power)
	cursor.global_position = hovered_node.global_position # good code moron
	if Input.is_action_just_pressed('move_hand_away') and hand.position.z >= -3 : hand.position.z -= 0.25
	elif Input.is_action_just_pressed('move_hand_close') and hand.position.z <= -1 : hand.position.z += 0.25

func rotate_pick_node(event):
	if picked_node:
		if event is InputEventMouseMotion:
			static_body_3d.rotate_x(deg_to_rad(event.relative.y*rotation_power))
			static_body_3d.rotate_y(deg_to_rad(event.relative.x*rotation_power))

#--------------------------------------------------------------------------------------------------
#Inventory

#func show_inventory():
#	mouse_lock = true
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	toggle_inventory.emit(self)
#
#func hide_inventory():
#	mouse_lock = false
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	toggle_inventory.emit(self)



#--------------------------------------------------------------------------------------------------

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	hide_inventory()

func _physics_process(delta):
	
#	player-related whatevers that don't require InputControllerFSM to be in a specific state, 
#	can't be in kinematic ground state or something because that isn't reserved for player
#	if you're looking for the other half of the strafing code or something look in
#	controller_move_state.gd dumbass [im sorry i shouldn't have said that i know this is messy]
	
	move_and_slide()
	
	if kinematic_controller_fsm.current_state is KinematicGroundState:
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
		
#	-----------------------------------------------------------------------------------------------

	if interact_ray.is_colliding():
		if interact_ray.get_collider() is Interactable or interact_ray.get_collider() is Pickable:
			if !hovered_node: on_node_hovered()

	elif hovered_node and !picked_node:
		on_node_unhovered()

	if picked_node: on_pick_node()
	elif hovered_node: on_hover_node()

func _input(event):
	if event is InputEventMouseMotion and !mouse_lock:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sense))
		neck_pivot.rotate_x(deg_to_rad(-event.relative.y*mouse_sense))
		neck_pivot.rotation.y = 0
		neck_pivot.rotation.x = clamp(neck_pivot.rotation.x,(deg_to_rad(-85)),(deg_to_rad(85)))
	
	elif Input.is_action_just_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("jump"): 
			jump.emit()
	
#	rotate grabbed object
	if Input.is_action_pressed('rotate_hand_toggle') and picked_node:
		mouse_lock = true
		rotate_pick_node(event)
	
	if Input.is_action_just_released('rotate_hand_toggle'): mouse_lock = false
	
##	inventory
#	if Input.is_action_just_pressed('toggle_inventory'): 
#		toggle_inventory.emit(self)
	
#	hovered object actions
#	using is_action_pressed prevents funkyness with lower end mice
	if Input.is_action_pressed('change_action_index_up') and hovered_node and action_index != hovered_node.actions.keys().max(): on_change_action_index_up.emit(self)
	elif Input.is_action_pressed('change_action_index_down') and hovered_node and action_index != 0: on_change_action_index_down.emit(self)
	
	if hovered_node is Interactable or Pickable and hovered_node:
#		shortcut input
		for i in hovered_node.actions.keys(): 
			if Input.is_action_just_pressed(hovered_node.actions[i]['Name']) and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				on_input(i)
		
#		mouse input
		if Input.is_action_just_pressed(hovered_node.actions[action_index]['Name']) and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			on_input(action_index)
		
		if Input.is_action_just_released('grab'):
			on_node_unpicked()
