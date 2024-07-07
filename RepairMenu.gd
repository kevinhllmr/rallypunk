extends Panel

func _ready():
	hide() 

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		hide()
		get_parent().get_node("Hud").show()
		
func _on_close_pressed():
	print("Close button pressed!")
	hide() 
	get_parent().get_node("Hud").show()

func _on_repair_pressed():
	print("Repair button pressed!")
	var car = get_parent()
	if car:
		car.remove_scrap(2)
