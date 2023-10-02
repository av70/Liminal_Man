extends State
class_name KinematicAirState

@onready var body = $"../.."
@onready var floor_raycast = $"../../FloorRaycast"
@onready var kinematic_ground_state = $"../KinematicGroundState"
@onready var direction = body.direction
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	var floor_target: Vector3 = floor_raycast.get_collision_point()
	if floor_target.y-0.2 < body.position.y or not floor_raycast.is_colliding():
		body.velocity.y -= gravity*delta

	else:
		state_complete.emit(kinematic_ground_state)
