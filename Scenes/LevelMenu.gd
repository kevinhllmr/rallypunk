extends Node2D

@onready var levelMenu = $Background
@onready var level1 = preload("res://Scenes/scene_tiles.tscn") as PackedScene
@onready var level2 = preload("res://Scenes/level2.tscn") as PackedScene
@onready var level3 = preload("res://Scenes/level3.tscn") as PackedScene

func _ready():
	Engine.time_scale = 0
	Settings.load_settings()
	PlayerStats.load_game_data()
	$Scrap.text = "Scrap: " + str(PlayerStats.scrap)
	$Background/Sprite2D/rank.text = "Rank " + str(PlayerStats.rank)
	$Background/Sprite2D/xp.text = str(PlayerStats.totalXP) + " XP"
	$Scrap.text = "Scrap: " + str(PlayerStats.scrap)
func _on_level_2_pressed():
	if(Settings.music <= 1.0):
		MusicManager.play_music("res://Sounds/Level2.wav")
	Engine.time_scale = 1
	PlayerStats.currentLevel = "res://Scenes/level2.tscn"
	get_tree().change_scene_to_packed(level2)


func _on_level_3_pressed():
	if(Settings.music <= 1.0):
		MusicManager.play_music("res://Sounds/level3.wav")
	PlayerStats.currentLevel = "res://Scenes/level3.tscn"
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(level3)



func _on_level_1_pressed():
	if(Settings.music <= 1.0):
		MusicManager.play_music("res://Sounds/Level1.wav")
	PlayerStats.currentLevel = "res://Scenes/scene_tiles.tscn"
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(level1)
