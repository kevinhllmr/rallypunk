extends Node2D

@onready var levelMenu = $Background
@onready var level1 = preload("res://Scenes/scene_tiles.tscn") as PackedScene
@onready var level2 = preload("res://Scenes/level2.tscn") as PackedScene
@onready var level3 = preload("res://Scenes/level3.tscn") as PackedScene
@onready var playerstats = "res://Scripts/player_stats.gd"
func _ready():
	Engine.time_scale = 0


func _on_level_2_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(level2)


func _on_level_3_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(level3)



func _on_level_1_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(level1)
