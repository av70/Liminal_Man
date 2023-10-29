extends Button

var action_data: DropdownActionData
signal action(node: Control)

func load_action(data: DropdownActionData):
	action_data = data
	text = data.text

func _on_pressed():
	print(action_data)
	action.emit(self)
