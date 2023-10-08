extends Consumable

func _ready():
	actions[2] = {'Title': 'Use', 'Name': 'use','Key': use,'Func':'on_use'}

func on_use():
	print('use')
