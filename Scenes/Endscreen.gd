extends Node2D
@onready var start = preload("res://Scenes/StartScreen.tscn") as PackedScene

func _ready():
	PlayerStats.collectedXP += 500

	# Format time as minutes:seconds:milliseconds
	var formatted_time = format_time(PlayerStats.time)
	$Background/VBoxContainer/time.text = formatted_time
	print(PlayerStats.time)
	PlayerStats.saveTime()

	$Background/VBoxContainer/collected_Scrap.text = "Scrap: " + str(PlayerStats.collectedScrap)
	$Background/VBoxContainer/collected_XP.text = "XP: " + str(PlayerStats.collectedXP) 
	PlayerStats.addScrap()
	PlayerStats.addXP()
	print(str(PlayerStats.uprank))
	PlayerStats.load_game_data()
	print(str(PlayerStats.currentLevel) + str(PlayerStats.time))

	# Display best time formatted
	var formatted_best_time = format_time(PlayerStats.time)
	$Background/VBoxContainer/bestTime.text = "Best: " + formatted_best_time + "\nCollected:"

	$Background/Sprite2D/rank.text = "Rank " + str(PlayerStats.rank)
	$Background/Sprite2D/XP.text = str(PlayerStats.totalXP) + " XP"
	$Background/ProgressBar.max_value = PlayerStats.uprank
	$Background/ProgressBar.value = PlayerStats.xp
	$Background/scrap.text = "Scrap: " + str(PlayerStats.scrap)

func _on_start_pressed():
	PlayerStats.save_game_data()
	get_tree().change_scene_to_packed(start)

func format_time(time_in_milliseconds):
	var total_seconds = int(time_in_milliseconds / 100)
	var minutes = int(total_seconds / 60)
	var seconds = total_seconds % 60
	var milliseconds = int(time_in_milliseconds % 100)

	# Format time as "mm:ss:ms"
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
