extends Pickable
class_name Consumable

@export var use: String = "%s" % InputMap.action_get_events('use')[0].as_text()

func on_use():
	pass
