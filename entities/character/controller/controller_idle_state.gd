extends State
class_name ControllerIdleState

@onready var player = $"../.."
@onready var direction = player.direction
@onready var current_speed = player.current_speed
@onready var controller_move_state = $"../ControllerMoveState"
@onready var floor_raycast = $"../../FloorRaycast"


func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	var floor_target: Vector3 = floor_raycast.get_collision_point()
	if Input.is_action_pressed('move'):
		state_complete.emit(controller_move_state)
	else:
		player.velocity.z = 0
		player.velocity.x = 0
#		player.move_and_slide()
