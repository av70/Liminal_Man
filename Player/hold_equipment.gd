extends Node3D
@onready var player = $"../../.."
@onready var equipment_slot_datas: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	equipment_slot_datas = player.inventory_data_equipment.slot_datas

func _unhandled_input(event):
	if Input.is_action_just_pressed('action'):
		pass
	elif Input.is_action_just_pressed('action_alt'):
		if player.equipment_slot_held >= 0:
			print(equipment_slot_datas[player.equipment_slot_held])
			print(player.equipment_slot_held)
	if Input.is_action_pressed('switch_equipment_neg') and Input.is_action_pressed("change_hold_item"):
		if  player.equipment_slot_held-1 >= -1:
			print('decreased')
			player.equipment_slot_held = player.equipment_slot_held-1
	elif Input.is_action_pressed('switch_equipment_pos') and Input.is_action_pressed("change_hold_item"):
		if  player.equipment_slot_held+1 <= 5:
			print('increased')
			player.equipment_slot_held = player.equipment_slot_held+1
