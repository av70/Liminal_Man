extends Control

var slot_scene = preload("res://entities/UI/inventory/slot/slot.tscn")
var grid_array : Array = [ ]
var inventory_data: InventoryData
var slot_size = 39

@onready var panel = $Panel

@onready var grid = $Panel/Grid
@onready var label = $Panel/Label


func get_index_from_grid_coords(x, y, columns) -> int:
	var index = y * columns + x
	return index

func get_grid_oords_from_index(index: int)-> Vector2:
	var coords = Vector2(index % inventory_data.columns,index / inventory_data.columns)
	return Vector2.ZERO

func get_slot_under_pos(pos) -> Control:
	for slot in grid_array:
		if slot.get_global_rect().has_point(pos):
			return slot
	return null


func is_grid_space_available(item_data: ItemData,slot: Control) -> bool:
	
	var x = slot.x
	var y = slot.y
	var width = item_data.width
	var height = item_data.height
	
	if x < 0 or y < 0:
		return false
	if x+width > inventory_data.columns or y+height > inventory_data.rows:
		return false
	for i in range(x,x+width):
		for j in range(y,y+height):
			if grid_array[j].item_data:
				return false
	return true

func _ready():
	load_inventory(preload("res://entities/UI/inventory/test_inventory.tres"))

func load_inventory(data: InventoryData):
	inventory_data = data
	label.text = inventory_data.title
	grid.columns = inventory_data.columns
	
	for child in grid.get_children():
		child.queue_free()
	
	for i in inventory_data.columns*inventory_data.rows:
		create_slot(i)
#
	grid.size.x = 0
	grid.size.y = 0
	panel.size.x = (inventory_data.columns*slot_size)+5
	panel.size.y = (inventory_data.rows*slot_size)+5
	size.x = (inventory_data.columns*slot_size)+5
	size.y = (inventory_data.rows*slot_size)+5
	panel.anchors_preset = PRESET_CENTER
	visible = true

func create_slot(index: int):
	var new_slot = slot_scene.instantiate()
	grid.add_child(new_slot)
	new_slot.slot_i = index
	grid_array.push_back(new_slot)
	new_slot.slot_i = index

	new_slot.x = index % inventory_data.columns
	new_slot.y = index / inventory_data.columns
	new_slot.item_data = null
	
	new_slot.slot_enter.connect(_on_slot_mouse_enter)
	new_slot.slot_leave.connect(_on_slot_mouse_leave)

func place(item_data: ItemData,slot: Control):
#	if is_grid_space_available(item_data,slot):
	print('able to place')
	

func _on_slot_mouse_enter():
	pass

func _on_slot_mouse_leave():
	pass
