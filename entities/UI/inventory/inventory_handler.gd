extends Control

var item_held: Control
var hovered_container: Control
var item_offset: Vector2

var cursor_position: Vector2
var place_position: Vector2
var place_position_slot_i: int
var place_slot_center: Vector2

var item_scene = preload('res://entities/UI/inventory/item/item.tscn')

signal item_dropped

@onready var container_inventory = $ContainerInventory/Canvas
@onready var player_inventory = $PlayerInventory/Canvas
@onready var equip_inventory = $EquipInventory/Canvas
@onready var item_backdrop = $ItemBackdrop

@onready var containers = [player_inventory,equip_inventory,container_inventory]

#------------------------------------------------------------------------------

func find_slot(item_is_rotated:bool,item:Item, container: Control,new_item:Control) -> void:
	for i in container.grid_array.size():
		if container.is_grid_space_available(new_item,i):
			place(item_is_rotated,item,container,i)
			return

func get_container_under_cursor(pos) -> Control:

	for container in containers:
		if container.get_global_rect().has_point(pos):
			return container
	return null

#------------------------------------------------------------------------------

func _ready():
	set_process_input(false)
	set_process(false)

func load_inventory(container:Control, data: InventoryData):
	
	container.load_inventory(data)
	
	for i in data.slot_data_array.size():
		var slot_data = data.slot_data_array[i]
		if slot_data:
		
			var new_item = item_scene.instantiate()
			new_item.item_data = slot_data.item_data
			print(slot_data.item_is_rotated)
			if !slot_data.item_is_rotated:
				new_item.rotated_width = new_item.item_data.width
				new_item.rotated_height = new_item.item_data.height
				new_item.rotated = false
		
			else:
				new_item.rotated_width = new_item.item_data.height
				new_item.rotated_height = new_item.item_data.width
				new_item.rotated = true
			
			new_item.resize(container.parent.scale.x)
			add_child(new_item)
			if container.is_grid_space_available(new_item,slot_data.index):
				place(new_item.rotated,new_item,container,slot_data.index)
			else:
				find_slot(new_item.rotated,new_item,container,new_item)
	
	container.update_inventory_data(data.slot_data_array)

func unload_inventory(container: Control, data: InventoryData ):
	
	container.unload_inventory(data)
	

func unload_items():
	
	if item_held: drop_item()
	
	for child in get_children():
		if child is Item:
			child.queue_free()

#------------------------------------------------------------------------------

# magic numbers are for borders/outlines of items/slots. probably.

func _process(delta) -> void:
	cursor_position = get_global_mouse_position()
	place_position = cursor_position
	hovered_container = get_container_under_cursor(place_position)
	
	if item_held:
		place_position += item_offset
		item_held.position = place_position
		place_slot_center = place_position - Vector2(item_held.slot_size * -0.5, item_held.slot_size * -0.5)
		
		if hovered_container:
			place_position_slot_i = hovered_container.get_index_under_pos(place_slot_center)
			
			if hovered_container.is_grid_space_available( item_held , place_position_slot_i):
				item_backdrop.visible = true
				item_backdrop.global_position = lerp( item_backdrop.global_position, hovered_container.grid_array[place_position_slot_i].global_position, 25 * delta)
				item_backdrop.size.x = hovered_container.parent.scale.x*( item_held.rotated_width * item_held.slot_size * hovered_container.scale.x)
				item_backdrop.size.y = hovered_container.parent.scale.y*( item_held.rotated_height * item_held.slot_size * hovered_container.scale.y)
	
			
			else: item_backdrop.visible = false
	
		else: item_backdrop.visible = false

func _input(event) -> void:
	if Input.is_action_just_pressed('inventory_grab'):
		
		if !item_held:
			grab(hovered_container)
		
		elif item_held:
			if hovered_container:
			
				if hovered_container.is_grid_space_available(item_held,place_position_slot_i):
					place(item_held.rotated,item_held,hovered_container,place_position_slot_i)
					item_held = null
			
			else: drop_item()
	
	if Input.is_action_just_pressed('inventory_rotate') and item_held and hovered_container:
		
		if item_held.rotated:
			item_held.rotated_width = item_held.item_data.width
			item_held.rotated_height = item_held.item_data.height
			item_held.rotated = false
		
		else:
			item_held.rotated_width = item_held.item_data.height
			item_held.rotated_height = item_held.item_data.width
			item_held.rotated = true
		
		item_held.resize(hovered_container.scale.x)

#------------------------------------------------------------------------------

func grab(container: Control) -> void:
	if container and container.has_method('grab_item'):
		item_held = container.grab_item(container.get_index_under_pos(place_position))
		if item_held:
#			last_container = container
#			last_global_position = item_held.global_position
			item_offset = item_held.global_position - cursor_position
			
			move_child(item_held,get_child_count())
			
			hovered_container.grid_array[hovered_container.get_index_under_pos(place_slot_center)].global_position

func place(item_is_rotated: bool, item: Item, container: Control,grid_index: int) -> void:
	
	var slot = container.grid_array[grid_index]
	var slot_coords = container.get_grid_coords_from_index(grid_index)
	
	item_backdrop.visible = false
	container.place(item_is_rotated,item,grid_index)
	
	item.position.x = (container.global_position.x + 1) + (slot_coords.x * container.parent.scale.x * (item.slot_size - 1))
	item.position.y = ( container.global_position.y + 1) + (slot_coords.y * container.parent.scale.y * (item.slot_size - 1))
	
	if item == item_held:
		item_held = null

func drop_item():
	item_dropped.emit(item_held)
	item_held.queue_free()
	item_held = null
