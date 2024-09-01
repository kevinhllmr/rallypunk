extends Node

var scrap = 0
var xp = 0
var collectedScrap = 0
var collectedXP = 0
var rank = 0
var totalXP = 0
var uprank = (pow(2,rank))*500



func rankupgrade():

	if xp>=uprank:
		xp = 0
		rank += 1
		rankupgrade()
func addXP(amount):
	xp =+ amount
	totalXP =+ amount
	rankupgrade()
	
func save_game_data():
	var save_data = {
		"scrap": scrap,
		"xp": xp,
		"rank": rank,
		"totalXP": totalXP
	}
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_game_data():
	if FileAccess.file_exists("user://savegame.dat"):
		var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		scrap = save_data["scrap"]
		xp = save_data["xp"]
		rank = save_data["rank"]
		totalXP = save_data["totalXP"]
