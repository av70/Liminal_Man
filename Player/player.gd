extends CharacterBody3D

@export var inventory_data: InventoryData
@export var inventory_data_equipment: InventoryDataEquipment
@export_range(-1,5) var equipment_slot_held: int = -1
var char_speed = 4.0 #changes when tip toing
const walk_speed = 4.0
#const tip_toe_speed = 2.0
#const run_speed = 6.0
const JUMP_VELOCITY = 4.5
const acceleration = 10
const max_speed = 500
const friction = 30

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var character_state = 'walking'
var forced_tip_toe = false
@onready var neck = $NeckPivot
@onready var camera = $NeckPivot/Camera
@onready var interact_ray = $NeckPivot/Camera/InteractRay
@onready var dungeon_ui = $"../DungeonUI"

#signal drop_item()

func _ready():
	PlayerManager.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event): 
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

	if Input.is_action_just_pressed("interact"):
		if dungeon_ui.find_child('InventoryInterface') and dungeon_ui.find_child('InventoryInterface').visible == false:
			on_interact()

#	if Input.is_action_just_pressed("drop_item"):
#		if Input.is_action_pressed('alternate'):
##			on_drop(true)
#			drop_item.emit(true)
#		else:
#			drop_item.emit(false)

	if Input.is_action_pressed("tip_toe") \
			or forced_tip_toe == true:
		character_state = 'tip_toeing'
	elif Input.is_action_pressed("run"):
		character_state = 'running'
	else:
		character_state = 'walking'


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		character_state = 'falling'
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not character_state == 'tip_toeing':
		velocity.y = JUMP_VELOCITY

	# move when key is pressed in direction camera faces
	var input_dir = Input.get_vector('strafe_left','strafe_right','move_front','move_back')
	
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = velocity.x+(direction.x*delta*.0010)
		velocity.z = velocity.z+(direction.z*delta*.001)
		velocity = velocity.clamp(Vector3(-(direction.x*max_speed),-999,-(direction.z*max_speed)),Vector3((direction.x*max_speed),-999,(direction.z*max_speed)))
	else:
		velocity = Vector3.ZERO
#		velocity.move_toward(Vector3.ZERO, friction*delta)
	print(velocity)
	move_and_slide()


# called either immediately after pressing e or after buffer finishes in DungeonUI.gd
func interact() -> void:
	if interact_ray.get_collider():
		interact_ray.get_collider().get_parent_node_3d().player_interact(self)

# called immediately after pressing e
func on_interact() -> void:
	if interact_ray.is_colliding():
		var node = interact_ray.get_collider().get_parent_node_3d()
		if node.slot_data and node.slot_data.item_data.enable_buffer == true:
			var buffer_time = node.slot_data.item_data.buffer
			var adjusted_buffer_time = buffer_time / node.slot_data.quantity
			dungeon_ui.start_buffer("interact",adjusted_buffer_time)
		elif node.slot_data:
			interact()

func interact_interface_buffer_finished(action_holded):
	forced_tip_toe = false
	if action_holded == 'interact':
		interact()

func interact_interface_buffer_cancelled():
	forced_tip_toe = false
