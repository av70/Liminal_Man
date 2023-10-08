extends RigidBody3D
class_name Pickable

# y yur clas iz saem as statik bowdi 3d clas bote riejed bodey 3d???????? 
#gaem suks yuz komponant noad -you (moron)

# no i don't want to -me (gigachad)!!!
@export var title: String 
@export var grab: String = "%s" % InputMap.action_get_events('grab')[0].as_text()
@export var collect: String = "%s" % InputMap.action_get_events('collect')[0].as_text()
@export var actions: Dictionary = {
	0: {
		'Title': 'Grab',
		'Name': 'grab',
		'Key': grab,
		'Func': 'on_grab',
	},
	1: {
		'Title': 'Collect',
		'Name': 'collect',
		'Key': collect,
		'Func': 'on_collect',
	},
}
func on_grab():
	print('grab')

func on_collect():
	print('collect')
