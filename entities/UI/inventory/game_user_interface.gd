extends CanvasLayer

@onready var inventory_handler = $PlayerUI/InventoryHandler

@onready var player_inventory_canvas = $PlayerUI/InventoryHandler/PlayerInventory/Canvas
@onready var container_inventory_canvas = $PlayerUI/InventoryHandler/ContainerInventory/Canvas
@onready var equip_inventory_canvas = $PlayerUI/InventoryHandler/EquipInventory/Canvas


@onready var hover_ui = $PlayerUI/Hover
@onready var hover_label = $PlayerUI/Hover/Label
@onready var hover_v_box_container = $PlayerUI/Hover/VBoxContainer

var highlight = preload("res://assets/ui/label_highlight.tres")
var white = preload("res://assets/ui/label_white.tres")



func show_inventory(player: Player):
	inventory_handler.unload_items()
	inventory_handler.set_process_input(true)
	inventory_handler.set_process(true)
	inventory_handler.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.mouse_lock = true 
	if player.player_inventory_data != null: inventory_handler.load_inventory(player_inventory_canvas, player.player_inventory_data)
	if player.equip_inventory_data != null: inventory_handler.load_inventory(equip_inventory_canvas,player.equip_inventory_data)
	if player.container_inventory_data != null: inventory_handler.load_inventory(container_inventory_canvas,player.container_inventory_data)

func hide_inventory(player: Player):
	inventory_handler.set_process_input(false)
	inventory_handler.set_process(false)
	inventory_handler.visible = false 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.mouse_lock = false 
	inventory_handler.unload_inventory(player_inventory_canvas, player.player_inventory_data)
	if player.equip_inventory_data != null: inventory_handler.unload_inventory(equip_inventory_canvas,player.equip_inventory_data)
	if player.container_inventory_data != null: inventory_handler.unload_inventory(container_inventory_canvas,player.container_inventory_data)
	inventory_handler.unload_items()

func on_toggle_inventory(player: Player):
	if inventory_handler.visible:
		hide_inventory(player)
	else:
		show_inventory(player)



func on_pickable_node_hovered(player: Player):
	
	if hover_ui.visible:
		hover_ui.visible = false
		for child in hover_v_box_container.get_children():
			child.queue_free()
		
	else:
		hover_ui.visible = true
		if player.hovered_node is Interactable or player.hovered_node is Pickable:
			hover_label.text = player.hovered_node.title
			for i in player.hovered_node.actions.keys():
				var dupe = hover_label.duplicate()
				hover_v_box_container.add_child(dupe)
				dupe.text = ('%s | %s' % [player.hovered_node.actions[i]['Title'],player.hovered_node.actions[i]['Key']])
			hover_v_box_container.get_child(player.action_index).set_label_settings(highlight)

func on_change_action_index_down(player: Player):
	hover_v_box_container.get_child(player.action_index).set_label_settings(white)
	player.action_index = player.action_index-1
	hover_v_box_container.get_child(player.action_index).set_label_settings(highlight)

func on_change_action_index_up(player: Player):
	hover_v_box_container.get_child(player.action_index).set_label_settings(white)
	player.action_index = player.action_index+1
	hover_v_box_container.get_child(player.action_index).set_label_settings(highlight)
