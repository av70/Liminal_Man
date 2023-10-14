extends Node

@onready var player = $Player
@onready var game_user_interface = $GameUserInterface


func _ready():
	player.toggle_inventory.connect(game_user_interface.on_toggle_inventory)
	player.on_pickable_node_hovered.connect(game_user_interface.on_pickable_node_hovered)
	player.on_change_action_index_down.connect(game_user_interface.on_change_action_index_down)
	player.on_change_action_index_up.connect(game_user_interface.on_change_action_index_up)
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

