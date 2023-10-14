extends Control
class_name Item

var item_data: ItemData = null
var index: int

func instance(container_scale:float):
	size.x = (size.x*item_data.width+(container_scale))
	size.y = (size.y*item_data.height+(container_scale))
	scale = Vector2(1*container_scale,1*container_scale)
