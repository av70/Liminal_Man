extends Control
class_name InventorySlot
#grid_dictionary[index] = { 'slot': new_slot, 'ID': index, 'x': index % inventory_data.columns,'y': index / inventory_data.columns,'item_data': null }

signal slot_enter
signal slot_leave

var slot_i: int
var x: int
var y: int
var item: Item
