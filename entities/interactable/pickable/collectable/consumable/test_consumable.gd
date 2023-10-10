extends Consumable

func _ready():
	actions[1] = {'Title': 'Use', 'Name': 'use','Key': collect,'Func':'on_collect'}
	actions[2] = {'Title': 'Use', 'Name': 'use','Key': use,'Func':'on_use'}

func on_use():
	print('use')
