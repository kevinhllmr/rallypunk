extends Label

func _ready():
	update_scrap_label()

func update_scrap_label():
	var car = get_parent().get_node("Car")  # Assuming Car is the name of your car instance
	if car:
		var scrap_count = car.get_scrap_count()
		text = "Scrap: " + str(scrap_count)
	else:
		text = "Scrap: 0"
