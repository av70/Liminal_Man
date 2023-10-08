extends State
class_name KinematicRagdollState

@onready var kinematic_ground_state = $"../KinematicGroundState"
@onready var ragdoll_collision = $"../../ragdoll_collision"
@onready var sneak_collision = $"../../sneak_collision"
@onready var stand_collision = $"../../stand_collision"
@onready var body = $"../.."
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	stand_collision.disabled = true
	sneak_collision.disabled = true
	ragdoll_collision.disabled = false



func _exit_state() -> void:
	set_physics_process(false)
	ragdoll_collision.disabled = true

func _physics_process(delta):
	body.velocity.y -= gravity*delta
#	state_complete.emit(kinematic_ground_state)
