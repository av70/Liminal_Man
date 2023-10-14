extends Collectable

func _ready():
	actions[1] = {'Title': 'Use', 'Name': 'collect','Key': collect,'Func':'on_collect'}
