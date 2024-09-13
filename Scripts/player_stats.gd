extends Node

var scrap = 0
var xp = 0
var collectedScrap = 0
var collectedXP = 0
var rank = 0
var totalXP = 0
var uprank = (pow(1.5, rank)) * 500
var currentLevel = "0"
var time = 0

func rankupgrade():
	uprank = (pow(1.5, rank)) * 500
	if xp >= uprank:
		xp -= uprank
		rank += 1
		save_game_data()
		rankupgrade()

func addXP():
	load_game_data()
	xp += collectedXP
	totalXP += collectedXP
	collectedXP = 0
	save_game_data()
	rankupgrade()
	
func save_game_data():
	var save_data = {
		"scrap": scrap,
		"xp": xp,
		"rank": rank,
		"totalXP": totalXP,
	}

	# Open existing save file for reading first to merge data
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
	var existing_data = {}
	if save_file:
		existing_data = save_file.get_var()
		save_file.close()

	# Merge existing level data if present
	if existing_data.has(currentLevel):
		save_data[currentLevel] = existing_data[currentLevel]
	else:
		save_data[currentLevel] = time

	# Write the updated save data back to the file
	save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_game_data():
	if FileAccess.file_exists("user://savegame.dat"):
		var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		scrap = save_data.get("scrap", 0)
		xp = save_data.get("xp", 0)
		rank = save_data.get("rank", 0)
		totalXP = save_data.get("totalXP", 0)
		time = save_data.get(currentLevel, 0)  # Retrieve stored time for the current level
	else:
		# For testing, set the initial values
		scrap = 0
		xp = 0
		rank = 0
		totalXP = 0

func collectScrap(amount):
	collectedScrap += amount
	
func addScrap():
	load_game_data()
	scrap += collectedScrap
	collectedScrap = 0
	save_game_data()

func timeClock():
	time += 1

func saveTime():
	var bestTime = 0
	if FileAccess.file_exists("user://savegame.dat"):
		var save_file2 = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data2 = save_file2.get_var()
		save_file2.close()
		if save_data2.has(currentLevel):
			bestTime = save_data2[currentLevel]
	
	# If bestTime is 0 (no time saved yet) or if current time is less than the best time, update it
	if bestTime == 0 or bestTime > time:
		var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ_WRITE)
		var save_data = save_file.get_var()
		save_file.close()
		save_data[currentLevel] = time
		save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
		save_file.store_var(save_data)
		save_file.close()
		time = 0
