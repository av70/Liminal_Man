extends State
class_name ControllerMoveState

@onready var player = $"../.."
@onready var floor_raycast = $"../../FloorRaycast"
@onready var kinematic_controller_fsm = $"../../KinematicControllerFSM"
@onready var direction = player.direction
@onready var jump_velocity = player.jump_velocity
@onready var controller_idle_state = $"../ControllerIdleState"
@onready var neck_pivot = $"../../NeckPivot"
@onready var player_audio = $"../../NeckPivot/PlayerAudio"


func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
#	if kinematic_controller_fsm.current_state == KinematicAirState or kinematic_controller_fsm.current_state == KinematicGroundState:
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_front", "move_back")
	
	direction = lerp(direction,(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*10)
	
	if direction:
		player.velocity.x = direction.x * player.current_speed
		player.velocity.z = direction.z * player.current_speed
	
	if  Input.is_action_pressed("strafe"): # bad no good
		neck_pivot.rotation.z = lerp(neck_pivot.rotation.z,input_dir.x*-0.05,5*delta)
		
	if direction.length() < 0.1:
		state_complete.emit(controller_idle_state)
	
	if !Input.is_action_pressed('sneak'):
		if Input.is_action_pressed('run'):
			player.current_speed = player.run_speed
		else:
			player.current_speed = player.walk_speed
