extends Control
class_name Item

var item_data: ItemData = null
var index: int
var slot_size: int = 40
var rotated_width: int
var rotated_height: int
var rotated: bool

func resize(container_scale:float):

	size.x = (rotated_width * (slot_size-1))
	size.y = (rotated_height * (slot_size-1))
	scale = Vector2(1 * container_scale, 1 * container_scale)
