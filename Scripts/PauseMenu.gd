extends Node2D

@onready var main = $"../"
@onready var statscontainer = $MarginContainer/StatsContainer
@onready var pausemenu = $MarginContainer/VBoxContainer
@onready var save_path = "user://stats.save"
@onready var total_distance_label = $MarginContainer/StatsContainer/HBoxContainer/ValueContainer/totalDistance_value
@onready var total_scrap_label = $MarginContainer/StatsContainer/HBoxContainer/ValueContainer/totalScrap_value

var total_distance: float = 0.0
var total_scrap: int = 0

func _on_resume_pressed():
	main.pauseMenu()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	statscontainer.hide()
	pausemenu.show()

func load_stats():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var data = file.get_var()  # Read the dictionary from the file
			total_distance = data.get("total_distance", 0.0)
			total_scrap = data.get("total_scrap", 0)
			file.close()
			update_labels()  # Update labels with loaded data

func update_labels():
	total_distance_label.text = str(round(total_distance)) + " meters"
	total_scrap_label.text = str(total_scrap)

func _on_statistics_pressed():
	pausemenu.hide()
	load_stats()
	statscontainer.show()

