extends Resource
class_name DropdownActionData

@export var type: String = 'Title'
@export var action: String = ' '
@export var function: String = ' ' # e.g functions 'hold_right' and 'hold_left' in seperate actions both are action 'hold'
@export var text: String = 'Text'
@export var lines: int = 0
@export var sub_dropdown_data: DropdownData
