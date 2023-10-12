extends CanvasLayer

@onready var inventory_panel = $PlayerUI/Inventory/Panel
@onready var inventory_ui = $PlayerUI/Inventory/Panel/ScrollContainer/Inventory
@onready var container_inventory_ui = $PlayerUI/Inventory/Panel/ScrollContainer/Inventory/ContainerInventory
@onready var player_inventory_ui = $PlayerUI/Inventory/Panel/ScrollContainer/Inventory/PlayerInventory
@onready var equip_inventory_ui = $PlayerUI/Inventory/Panel/ScrollContainer/Inventory/EquipInventory

@onready var hover_ui = $PlayerUI/Hover
@onready var hover_label = $PlayerUI/Hover/Label
@onready var hover_v_box_container = $PlayerUI/Hover/VBoxContainer



var container_inventory_slot = preload("res://entities/UI/inventory/slot/container_inventory_slot.tscn")
var player_inventory_slot = preload("res://entities/UI/inventory/slot/player_inventory_slot.tscn")
var equip_inventory_slot = preload("res://entities/UI/inventory/slot/equip_inventory_slot.tscn")

var highlight = preload("res://assets/ui/label_highlight.tres")
var white = preload("res://assets/ui/label_white.tres")

#
#func show_inventory(player: Player):
#	inventory_panel.visible = true
#	player.mouse_lock = true
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE	)
#	if player.player_inventory: inventory_ui.populate_inventory(player_inventory_ui,player.player_inventory,player_inventory_slot)
#	if player.container_inventory: inventory_ui.populate_inventory(container_inventory_ui,player.container_inventory,container_inventory_slot)
#	if player.equip_inventory: inventory_ui.populate_inventory(equip_inventory_ui,player.equip_inventory,equip_inventory_slot)
#
#func hide_inventory(player: Player):
#	inventory_panel.visible = false
#	player.mouse_lock = false
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	inventory_ui.clear_inventory(player_inventory_ui)
#	inventory_ui.clear_inventory(container_inventory_ui)
#	inventory_ui.clear_inventory(equip_inventory_ui)

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
#
#func on_toggle_inventory(player: Player):
#	if inventory_panel.visible:
#		hide_inventory(player)
#	else:
#		show_inventory(player)
