extends Node2D

@onready var main = $"../"

func _on_resume_pressed():
	main.pauseMenu() # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
