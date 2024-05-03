class_name MainMenu
extends Control

@onready var button_1 = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button1 as Button
@onready var button_2 = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button2 as Button
@onready var start_scene = preload("res://main.tscn") as PackedScene

func _ready():
	button_1.button_down.connect(start_button_pressed)
	button_2.button_down.connect(exit_button_pressed)

func start_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)
	
func exit_button_pressed() -> void:
	get_tree().quit()
