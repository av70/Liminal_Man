extends State
class_name KinematicGroundState

var last_step_time: float = 0

@onready var floor_raycast = $"../../FloorRaycast"
@onready var body = $"../.."
@onready var direction = body.direction
@onready var jump_velocity = body.jump_velocity
@onready var kinematic_air_state = $"../KinematicAirState"
@onready var neck_pivot = $"../../NeckPivot"
@onready var player_audio = $"../../NeckPivot/PlayerAudio"


func _ready():
	set_physics_process(false)
	body.jump.connect(jump)

func _enter_state() -> void:
	set_physics_process(true)
	player_audio.play_land_audio()

func _exit_state() -> void:
	set_physics_process(false)

func jump():
	player_audio.play_jump_audio()
	body.velocity.y = jump_velocity
	state_complete.emit(kinematic_air_state)

func _physics_process(delta):
	if floor_raycast.is_colliding():
		var floor_target: Vector3 = floor_raycast.get_collision_point()
		body.velocity.y = 0
		body.position.y = lerp(body.position.y,floor_target.y,body.direction.length()*10*delta)
		
		if floor_target.y-0.2 < body.position.y and body.velocity.z != 0:
			if last_step_time > 2.5/body.current_speed-0.1:
				last_step_time = 0
				player_audio.play_walk_audio()
		last_step_time = last_step_time+delta

	else:
		state_complete.emit(kinematic_air_state)
