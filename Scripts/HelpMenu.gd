extends Node2D

func show_menu(visible: bool):
	self.visible = visible
	
func _on_close_pressed():
	self.visible = false
	var start_screen_buttons = get_parent().get_node("Sprite2D/VBoxContainer")
	if start_screen_buttons:
		start_screen_buttons.visible = true
