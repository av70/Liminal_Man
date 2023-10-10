extends RigidBody3D
class_name Pickable

@export var title: String 
@export var grab: String = "%s" % InputMap.action_get_events('grab')[0].as_text()
@export var actions: Dictionary = {
	0: {
		'Title': 'Grab',
		'Name': 'grab',
		'Key': grab,
		'Func': 'on_grab',
	},
}
func on_grab():
	print('grab')
