extends Node2D

func _ready():
	PlayerStats.addXP(10000)
	print(str(PlayerStats.xp))
	$Background/Sprite2D/rank.text = "Rank: " + str(PlayerStats.rank)
	$Background/Sprite2D/XP.text = "XP: " + str(PlayerStats.xp)
	$Background/ProgressBar.max_value = PlayerStats.uprank
	$Background/ProgressBar.value = PlayerStats.xp
	$Background/VBoxContainer/collected_Scrap.text = "Scrap: " + str(PlayerStats.collectedScrap)
	$Background/VBoxContainer/collected_XP.text = "XP: " + str(PlayerStats.xp)
	
