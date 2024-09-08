extends Area3D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	$AnimationPlayer.play("item_rotation")
func _on_body_entered(body):
	if body.is_in_group("car"):
		body.pick_up_scrap()
		print("Item collected!")
		queue_free() 
