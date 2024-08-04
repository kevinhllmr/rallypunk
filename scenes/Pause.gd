extends Node2D

@onready var main = $"../"



func _on_quit_button_down():
	get_tree().quit()


func _on_resume_button_down():
	main.pauseMenu()
