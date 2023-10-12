extends Control
class_name InventorySlot
#grid_dictionary[index] = { 'slot': new_slot, 'ID': index, 'x': index % inventory_data.columns,'y': index / inventory_data.columns,'item_data': null }

signal slot_enter
signal slot_leave

@export var slot_i: int
@export var x: int
@export var y: int
@export var item_data: ItemData
