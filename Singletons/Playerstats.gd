extends Node

var time = 0
var scrap_count: int = 0

var save_path = "user://variable.save"

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(time)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		time = file.get_var(time)
	else: 
		print("No Data Available!")

func _physics_process(delta):
	print (time)

