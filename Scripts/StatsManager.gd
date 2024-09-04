extends Node

@export var save_path: String = "user://stats.save"
var total_distance: float = 0.0
var total_scrap: int = 0

func _ready():
	load_stats()

# Save data using mapping
func save_stats():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		# Create a dictionary with keywords and values
		var data = {
			"total_distance": total_distance,
			"total_scrap": total_scrap
		}
		
		# Write the dictionary to file
		file.store_var(data)
		file.close()
		print("Stats saved:", data)
	else:
		print("Failed to open file for saving.")

# Load data using mapping
func load_stats():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			# Read the dictionary from file
			var data = file.get_var()
			total_distance = data.get("total_distance", 0.0)
			total_scrap = data.get("total_scrap", 0)
			file.close()
			print("Stats loaded:", data)
		else:
			print("Failed to open file for reading.")
	else:
		print("File does not exist.")

# Example methods to change values and save
func save_total_distance(new_distance: float):
	total_distance = new_distance
	save_stats()

func save_total_scrap(new_scrap: int):
	total_scrap = new_scrap
	save_stats()
