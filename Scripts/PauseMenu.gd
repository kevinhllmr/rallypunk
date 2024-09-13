extends Node2D

@onready var main = $"../"
@onready var start_scene = load("res://Scenes/StartScreen.tscn") as PackedScene
@onready var restart = load(PlayerStats.currentLevel) as PackedScene


func _on_resume_pressed():
	main.pauseMenu() # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

func _on_to_menu_pressed():
	get_tree().change_scene_to_packed(start_scene)



func _on_restart_pressed():
	get_tree().change_scene_to_packed(restart)
