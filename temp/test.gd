extends Button

var dropdown_scene = preload("res://entities/UI/generic/dropdown/dropdown.tscn")
var dropdown_data  = preload("res://temp/new_resource.tres")

func _on_pressed():
	print('a')
	var dropdown = dropdown_scene.instantiate()
	add_child(dropdown)
	dropdown.load_actions(dropdown_data)
	dropdown.global_position = get_global_mouse_position()
	dropdown.action.connect(on_action)

func on_action(action_data: DropdownActionData):
	match action_data.function:

		'drop':
			print(action_data.action)

		'hold':
			print(action_data.action)

		'quick_select':
			print(action_data.action)
