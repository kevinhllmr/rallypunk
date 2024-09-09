extends Node2D
@onready var start = preload("res://Scenes/StartScreen.tscn") as PackedScene


func _ready():
	PlayerStats.collectedXP = 2500
	$Background/VBoxContainer/collected_Scrap.text = "Scrap: " + str(PlayerStats.collectedScrap)
	$Background/VBoxContainer/collected_XP.text =  "XP: " +str(PlayerStats.collectedXP) 

	PlayerStats.addXP()
	print(str(PlayerStats.uprank))
	$Background/Sprite2D/rank.text = "Rank " + str(PlayerStats.rank)
	$Background/Sprite2D/XP.text =  str(PlayerStats.totalXP) + " XP"
	$Background/ProgressBar.max_value = PlayerStats.uprank
	$Background/ProgressBar.value = PlayerStats.xp


func _on_start_pressed():
	PlayerStats.save_game_data()
	get_tree().change_scene_to_packed(start)
