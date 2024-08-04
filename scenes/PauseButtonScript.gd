extends VBoxContainer

@onready var pause = $"../../"

func _on_resume_button_down():
	pause.pauseMenu() # Replace with function body.


func _on_quit_button_down():
	get_tree().quit() # Replace with function body.
