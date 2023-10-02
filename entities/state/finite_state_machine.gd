extends Node
class_name FiniteStateMachine

@export var current_state : State

func _ready():
	for child in get_children():
		if child is State:
			child.state_complete.connect(on_state_complete)
	current_state._enter_state()

func change_state(new_state: State):
	current_state._exit_state()
	new_state._enter_state()
	current_state = new_state

func on_state_complete(state : State):
	change_state(state)
