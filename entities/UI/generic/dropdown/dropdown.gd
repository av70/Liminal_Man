extends Control
class_name Dropdown

var title = preload("res://entities/UI/generic/dropdown/actions/title.tscn")
var blurb = preload("res://entities/UI/generic/dropdown/actions/blurb.tscn")
var button = preload("res://entities/UI/generic/dropdown/actions/button.tscn")
var subdropdown_button = preload("res://entities/UI/generic/dropdown/actions/subdropdown_button.tscn")

var dropdown_scene = preload("res://entities/UI/generic/dropdown/dropdown.tscn")

var test_data = preload("res://temp/new_resource.tres")
#
#var rect: Control

var subdropdown: Control

signal action(data: DropdownActionData)

@onready var v_box_container = $Panel/VBoxContainer
@onready var panel = $Panel

func on_subdropdown_action(data: DropdownActionData):
	action.emit(data)

func on_action(node: Control) -> void:
	if node.action_data:
		print('eff')
		action.emit(node.action_data)
		if node.action_data.type == 'SubdropdownButton':
			if !subdropdown:
				subdropdown = dropdown_scene.instantiate()
				node.add_child(subdropdown)
				subdropdown.load_actions(node.action_data.sub_dropdown_data)
				subdropdown.action.connect(on_subdropdown_action)
				subdropdown.global_position = node.global_position+Vector2(10+node.size.x,0) # border
#			else:
#				subdropdown.queue_free()
#				subdropdown = null

func is_pos_in_bounds(pos: Vector2)-> bool:
	if get_global_rect().has_point(pos):
		print('%s' % [get_global_rect().has_point(pos)]) 
		return true
	elif subdropdown:
		if subdropdown.get_global_rect().has_point(pos): return true
		else: return false

	return false
	

func load_actions(data: DropdownData) -> void:
	for child in v_box_container.get_children():
		child.queue_free()
	
	var height = 0
	if data:
		for action_data in data.actions_array:
			if action_data:
				var child
				match action_data.type:
					'Title':
						child = title.instantiate()
					'Blurb':
						child = blurb.instantiate()
					'Button':
						child = button.instantiate()
						child.action.connect(on_action)
					'SubdropdownButton':
						child = subdropdown_button.instantiate()
						child.action.connect(on_action)
				if child:
					child.load_action(action_data)
					if child: v_box_container.add_child(child)
					height = child.size.y+height+4
	
	size.x = data.width
	size.y = height
