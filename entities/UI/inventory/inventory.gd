extends Control

var slot_scene = preload("res://entities/UI/inventory/slot/slot.tscn")
var grid_array : Array = [ ]
var inventory_data: InventoryData
var slot_size = 39

@onready var panel = $Panel

@onready var grid = $Panel/Grid
@onready var label = $Panel/Label
@onready var parent = $".."

func get_index_from_grid_coords(x, y) -> int:
	var index = y * inventory_data.columns + x
	return index

func get_grid_coords_from_index(index: int)-> Vector2:
	var  coords = Vector2(index % inventory_data.columns,index / inventory_data.columns)
	return coords

func get_index_under_pos(pos) -> int:
	var index = 0
	for slot in grid_array:
		if slot.get_global_rect().has_point(pos):
			return index
		index = index+1
	return 0

func is_grid_space_available(item: Item,slot_index: int) -> bool:
	var x = get_grid_coords_from_index(slot_index).x
	var y = get_grid_coords_from_index(slot_index).y
	var width = item.item_data.width
	var height = item.item_data.height
	if x < 0 or y < 0:
		return false
	if x+width > inventory_data.columns or y+height > inventory_data.rows:
		return false
	for i in range(x,x+width):
		for j in range(y,y+height):
			if grid_array[get_index_from_grid_coords(i,j)].item != null:
				return false
	return true

func load_inventory(data: InventoryData):
	inventory_data = data
	label.text = inventory_data.title
	grid.columns = inventory_data.columns
	
	for child in grid.get_children():
		child.queue_free()
	
	for i in inventory_data.columns*inventory_data.rows:
		create_slot(i)
#
	panel.size.x = (inventory_data.columns*slot_size)+5
	panel.size.y = (inventory_data.rows*slot_size)+5
	size.x = (inventory_data.columns*slot_size)+5
	size.y = (inventory_data.rows*slot_size)+5
	anchors_preset = PRESET_CENTER
	panel.anchors_preset = PRESET_CENTER
	position.x = inventory_data.posx*scale.x-(size.x/2)
	
	set_process_input(false)
	
	visible = true

func unload_inventory(data: InventoryData):
	
	visible = false
	
	set_process_input(false)
	
	data.slot_data_array = update_inventory_data(data.slot_data_array)
	
	for child in grid.get_children():
		child.queue_free()
	
	grid_array = [ ]


func create_slot(index: int):
	var new_slot = slot_scene.instantiate()
	grid.add_child(new_slot)
	new_slot.slot_index = index
	grid_array.push_back(new_slot)
	new_slot.slot_index = index
#
#	new_slot.x = index % inventory_data.columns
#	new_slot.y = index / inventory_data.columns
	new_slot.item = null
	

func change_slot_item(item_data: ItemData, slot: Control):
	for i in range(slot.x,slot.x+item_data.width):
		for j in range(slot.y,slot.y+item_data.height):
			grid_array[j].item_data = item_data


func place(item: Item, slot_index: int):
	var slot = grid_array[slot_index]
	var slot_coords = get_grid_coords_from_index(slot_index)
	item.index = slot_index
	for x in range(slot_coords.x,item.item_data.width+slot_coords.x):
			for y in range(slot_coords.y,item.item_data.height+slot_coords.y):
				grid_array[get_index_from_grid_coords(x,y)].item = item

func grab_item(index:int):
	print('e')
	var slot = grid_array[index]
	var item = slot.item
	if item:
		var item_coords = get_grid_coords_from_index(item.index)
		for x in range(item_coords.x,item.item_data.width+item_coords.x):
				for y in range(item_coords.y,item.item_data.height+item_coords.y):
					grid_array[get_index_from_grid_coords(x,y)].item = null
		return item

func _on_slot_mouse_enter():
	pass

func _on_slot_mouse_leave():
	pass

func update_inventory_data(slot_data_array) -> Array:
	slot_data_array.clear()
	for slot in grid_array:
		if slot.item:
			if slot.slot_index == slot.item.index:
				print('i love men')
				var slot_data = SlotData.new() 
				slot_data.index = slot.slot_index
				slot_data.item_data = slot.item.item_data
				inventory_data.slot_data_array.push_back(slot_data)
	
	return slot_data_array
