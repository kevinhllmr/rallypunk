extends Panel

func _ready():
	hide() 

func _on_close_pressed():
	hide() 
	get_parent().get_node("Hud").show()

func _on_repair_pressed():
	var car = get_parent()
	if car:
		car.remove_scrap(1)
