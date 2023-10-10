extends Control
class_name InventorySlot

@onready var weight_label = $Panel/Weight
@onready var volume_label = $Panel/Volume
@onready var name_label = $Panel/Name


func set_slot_data(item_data:ItemData):
	name_label.text = item_data.name
	weight_label.text = '%s' % item_data.mass
	volume_label.text = '%s' % item_data.volume
