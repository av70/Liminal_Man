extends CharacterBody3D
class_name HumanEntity

@export var walk_speed: int = 4
@export var run_speed: int = 6
@export var sneak_speed: int = 2
@export var current_speed: int = 4
@export var jump_velocity: int  = 3
@export var direction: Vector3 = Vector3(0,0,0)

@export var energy: float = 100
@export var saturation: float = 100
@export var hydration: float = 100
@export var bladder: float = 100

signal jump

