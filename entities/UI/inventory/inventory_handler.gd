extends Control

var item_held: Control

var item_offset: Vector2
var last_container: Control
var last_global_position: Vector2
var cursor_position: Vector2
var place_position: Vector2

var slot_size: int = 39

var item_scene = preload('res://entities/UI/inventory/item/item.tscn')

signal item_dropped

@onready var container_inventory = $ContainerInventory/Canvas

@onready var player_inventory = $PlayerInventory/Canvas

@onready var equip_inventory = $EquipInventory/Canvas

@onready var containers = [player_inventory,equip_inventory,container_inventory]


func _ready():
#	item_held = $Item
#
#	player_inventory.load_inventory(preload('res://entities/UI/inventory/test_inventory.tres'))
#	var gorm = preload('res://entities/UI/inventory/test_inventory.tres')
#	equip_inventory.load_inventory(preload('res://entities/UI/inventory/test_inventory.tres'))
	load_inventory(equip_inventory,preload('res://entities/UI/inventory/test_equip_inventory.tres'))
	load_inventory(player_inventory,preload('res://entities/UI/inventory/test_player_inventory.tres'))
	load_inventory(container_inventory,preload('res://entities/UI/inventory/test_container_inventory.tres'))
#	container_inventory.position = 
	

func load_inventory(container:Control, data: InventoryData):
	
	container.load_inventory(data)
	
	
	for slot in data.slot_data_array:
		if slot:
			var new_item = item_scene.instantiate()
			new_item.item_data = slot.item_data
			new_item.instance(container.parent.scale.x)
			add_child(new_item)
			if container.is_grid_space_available(new_item,slot.index):
				place(new_item,container,slot.index)
			else:
				find_slot(container,new_item)
			

func find_slot(container: Control,new_item:Control) -> void:
	for i in container.slot_array.size():
		if container.is_grid_space_available(new_item,i):
			place(new_item,container,i)
			return

func get_container_under_cursor(pos) -> Control:

	for container in containers:
		if container.get_global_rect().has_point(pos):
			return container
	return null

func _process(_delta) -> void:
	cursor_position = get_global_mouse_position()
	place_position = cursor_position
	if item_held:
		place_position += item_offset
		item_held.position = place_position

func _input(event) -> void:
	if Input.is_action_just_pressed('inventory_grab'):
		if !item_held:
			var container = get_container_under_cursor(place_position)
			grab(container)
		else:
			var container = get_container_under_cursor(place_position)
			if container and item_held:
				if container.is_grid_space_available(item_held,container.get_index_under_pos(place_position-Vector2(-40,-40))):
					place(item_held,container,container.get_index_under_pos(place_position-Vector2(-40,-40)))
					item_held = null

func grab(container: Control) -> void:
	print('a')
	if container and container.has_method('grab_item'):
		print('fff')
		item_held = container.grab_item(container.get_index_under_pos(place_position))
		if item_held:

			last_container = container
			last_global_position = item_held.global_position
			item_offset = item_held.global_position - cursor_position
			move_child(item_held,get_child_count())


func place(item:Control, container: Control,slot_index: int) -> void:
#	if container.is_grid_space_available(slot.item_data,slot_index):
	var slot_scale = slot_size*container.parent.scale.x
	var slot = container.slot_array[slot_index]
	container.place(item,slot_index)
	item.position = Vector2(slot_scale*slot.x+container.global_position.x+5,slot_scale*slot.y+container.global_position.y+5)
	if item == item_held:
		item_held = null
#		set_process(false)

func drop_item():
	item_dropped.emit(item_held)
	item_held.queue_free()
	item_held = null

func return_item():
	item_held.rect_global_position = last_global_position
	last_container.insert_item(item_held)
	item_held = null
