extends Node2D

@onready var main = $"../"
@onready var menu = preload("res://Scenes/LevelMenu.tscn") as PackedScene


func _on_resume_pressed():
	main.pauseMenu() # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	



func _on_to_menu_pressed():
	get_tree().change_scene_to_packed(menu)

