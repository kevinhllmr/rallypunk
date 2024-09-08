extends Node2D

@onready var start_scene = preload("res://Scenes/LevelMenu.tscn") as PackedScene


func _on_start_pressed():
	get_tree().change_scene_to_packed(start_scene)


func _on_exit_pressed():
	get_tree().quit()
