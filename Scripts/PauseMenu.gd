extends Node2D

@onready var main = $"../"
@onready var start_scene = preload("res://Scenes/StartScreen.tscn") as PackedScene

func _on_resume_pressed():
	main.pauseMenu() # Replace with function body.


func _on_quit_pressed():
	get_tree().change_scene_to_packed(start_scene)
