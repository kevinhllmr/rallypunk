extends Area3D

@onready var endscreen = load("res://Scenes/Endscreen.tscn") as PackedScene

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func _on_body_entered(body):
	if body.is_in_group("car"):
		$TransitionScreen.transition()
		
func _on_transition_screen_transitioned():
	get_tree().change_scene_to_packed(endscreen)

