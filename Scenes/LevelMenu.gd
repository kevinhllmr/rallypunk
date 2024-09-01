extends Node2D

@onready var levelMenu = $Background
@onready var start_scene = preload("res://Scenes/scene_tiles.tscn") as PackedScene
@onready var playerstats = "res://Scripts/player_stats.gd"
func _ready():
	Engine.time_scale = 0

func _on_button_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(start_scene)
	
