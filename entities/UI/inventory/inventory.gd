extends Control

var slot_scene = preload("res://entities/UI/inventory/slot/slot.tscn")
var grid_array : Array = [ ]
var inventory_data: InventoryData
var slot_size = 39

@onready var panel = $Panel

@onready var grid = $Panel/Grid
@onready var label = $Panel/Label
@onready var parent = $".."

#TODO ponder the existance of slot resource with slot_data resource

#------------------------------------------------------------------------------

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
	var width = item.rotated_width
	var height = item.rotated_height
	if x < 0 or y < 0:
		return false
	if x+width > inventory_data.columns or y+height > inventory_data.rows:
		return false
	for i in range(x,x+width):
		for j in range(y,y+height):
			if grid_array[get_index_from_grid_coords(i,j)].item != null:
				return false
	return true


func create_slot(index: int):
	var new_slot = slot_scene.instantiate()
	grid.add_child(new_slot)
	new_slot.slot_index = index
	grid_array.push_back(new_slot)
	new_slot.slot_index = index
	new_slot.item = null

#------------------------------------------------------------------------------

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

func place(item_is_rotated: bool, item:Item, grid_index: int):
	var slot = grid_array[grid_index]
	var slot_coords = get_grid_coords_from_index(grid_index)
	item.index = grid_index
	for x in range(slot_coords.x,item.rotated_width+slot_coords.x):
			for y in range(slot_coords.y,item.rotated_height+slot_coords.y):
				grid_array[get_index_from_grid_coords(x,y)].item = item
				grid_array[get_index_from_grid_coords(x,y)].item_is_rotated = item_is_rotated

func get_item(index: int):
	var slot = grid_array[index]

	return slot.item

func grab_item(index:int):
	var item = get_item(index)
	if item:
		var item_coords = get_grid_coords_from_index(item.index)
		for x in range(item_coords.x,item.rotated_width+item_coords.x):
				for y in range(item_coords.y,item.rotated_height+item_coords.y):
					grid_array[get_index_from_grid_coords(x,y)].item = null
		return item



# called when player closes inventory screen

func update_inventory_data(slot_data_array) -> Array:
	slot_data_array.clear()
	for slot in grid_array:
		if slot.item:
			if slot.slot_index == slot.item.index:
				var slot_data = SlotData.new() 
				slot_data.index = slot.slot_index
				slot_data.item_data = slot.item.item_data
				slot_data.item_is_rotated = slot.item_is_rotated
				inventory_data.slot_data_array.push_back(slot_data)
	
	return slot_data_array
