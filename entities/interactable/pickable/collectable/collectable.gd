extends Pickable
class_name Collectable

@export var collect: String = "%s" % InputMap.action_get_events('collect')[0].as_text()

func on_collect():
	print('collect')
