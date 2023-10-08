extends StaticBody3D
class_name Interactable

@export var title: String 
@export var use: String = "%s" % InputMap.action_get_events('use')[0].as_text()
@export var actions: Dictionary = {0: {'Title': 'Use','Name': 'use','Key': use,'Func': 'on_use'}}

func on_use():
	pass
