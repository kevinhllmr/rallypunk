extends Node2D

@onready var start_scene = preload("res://Scenes/LevelMenu.tscn") as PackedScene
@onready var upgrade_menu = $UpgradeMenu
@onready var buttons = $Sprite2D/VBoxContainer

func _ready():
	
	upgrade_menu.visible = false
	#MusicManager.play_music("res://Sounds/Menu.wav")
	#MusicManager.set_volume(Settings.volume)
	
func _on_start_pressed():
	get_tree().change_scene_to_packed(start_scene)

func _on_exit_pressed():
	get_tree().quit()


func _on_upgrade_pressed():
	upgrade_menu.show_menu(true) 
	buttons.visible = false
	



func _on_settings_pressed():
	$Settings.show_menu(true)
	buttons.visible=false
