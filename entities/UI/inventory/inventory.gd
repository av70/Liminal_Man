extends GridContainer



func populate_inventory(inventory_ui: GridContainer,inventory_data: InventoryData,slot):
	clear_inventory(inventory_ui)
	var container = inventory_ui.find_child('Container')
	container.find_child('Panel').find_child('MaxVolume').text = '%s' % inventory_data.max_volume
	container.find_child('Panel').find_child('MaxWeight').text = '%s' % inventory_data.max_mass
	for item_data in inventory_data.item_array:
		if item_data:
			var new_slot = slot.instantiate()
			inventory_ui.add_child(new_slot)
			new_slot.set_slot_data(item_data)
	
	inventory_ui.visible = true

func clear_inventory(inventory_ui: GridContainer):
	inventory_ui.visible = false
	for child in inventory_ui.get_children():
		if child is InventorySlot:
			child.queue_free()
