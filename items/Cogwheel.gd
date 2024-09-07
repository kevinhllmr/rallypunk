extends Node3D
@export var speed: float = 5

func _process(delta):
	rotate_y(speed * delta)
