extends Control

var item_held

var item_offset: Vector2
var last_container: Control
var last_global_position: Vector2
var cursor_position: Vector2
var slot_size: int = 39


signal item_dropped

@onready var containerinventory = $Containerinventory

@onready var player_inventory = $PlayerInventory

@onready var equip_inventory = $EquipInventory

@onready var containers = [equip_inventory,player_inventory,containerinventory]

func _ready():
	item_held = $Item
	

func get_container_under_cursor(pos) -> Control:
#	print(container_storage.has_point(cursor_position))
	for container in containers:
		if container.get_global_rect().has_point(pos):
			print('true')
			return container
	return null

func _process(delta) -> void:
	cursor_position = get_global_mouse_position()
	if item_held:
		item_held.global_position = cursor_position+item_offset

func _input(event) -> void:
	if Input.is_action_just_pressed('inventory_grab'):
#		grab(cursor_position)
#	elif Input.is_action_just_released('inventory_grab'):
		print('a')
		print(cursor_position)
		place()


func grab() -> void:
	var container = get_container_under_cursor(cursor_position)
	if container and container.has_method('grab_item'):
		item_held = container.grab_item(cursor_position)
		if item_held:
			last_container = container
			last_global_position = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_position
			move_child(item_held,get_child_count())


func place() -> void:
#	if !item_held:
#		return

	var container = get_container_under_cursor(cursor_position)
	print(container)
	if container:
		if container.is_grid_space_available(item_held.item_data,container.get_slot_under_pos(cursor_position)):
			var slot = container.get_slot_under_pos(cursor_position)
			var slot_scale = slot_size*container.scale.x
			container.place(item_held.item_data,slot)
			item_held.position = Vector2(slot_scale*slot.x+container.global_position.x+5,slot_scale*slot.y+container.global_position.y+5)
			print(slot.y)
			item_held = null
			
#		


func drop_item():
	item_dropped.emit(item_held)
	item_held.queue_free()
	item_held = null

func return_item():
	item_held.rect_global_position = last_global_position
	last_container.insert_item(item_held)
	item_held = null
