extends Node2D

var resolution = 0
var music = 100
var sfx = 100

@onready var music_slider = $MarginContainer/VBoxContainer/VolumeMusic
@onready var sfx_slider = $MarginContainer/VBoxContainer/VolumeEffekts

func _ready():
	setUP()

func setUP():
	load_settings()
	changeResolution(resolution)
	changeSFX(sfx)
	changeMusic(music)
	
func _on_option_button_item_selected(index):
	changeResolution(index)

func _on_h_slider_value_changed(value):
	changeMusic(value)

func changeResolution(index):
	match index:
		4:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		0:
			DisplayServer.window_set_size(Vector2i(3840,2160))

func changeMusic(value):
	music = value
	if music_slider:
		music_slider.value = value
		MusicManager.set_music(value)
	save_settings()
	
func changeSFX(value):
	sfx = value
	if sfx_slider:
		sfx_slider.value = value
		MusicManager.set_sfx(value)
	save_settings()

func save_settings():
	var save_data = {
		"resolution": resolution,
		"music": music,
		"sfx": sfx,
	}
	var save_file = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_settings():
	if FileAccess.file_exists("user://settings.dat"):
		var save_file = FileAccess.open("user://settings.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		if "resolution" in save_data:
			resolution = save_data["resolution"]
		if "music" in save_data:
			music = save_data["music"]
		if music_slider:
				music_slider.value = music
		if "sfx" in save_data:
			sfx = save_data["sfx"]
		if sfx_slider:
				sfx_slider.value = sfx
	else:
		resolution = 2
		music = 100
		sfx = 100
		
func show_menu(visible: bool):
	self.visible = visible

func _on_close_pressed():
	self.visible = false
	var start_screen_buttons = get_parent().get_node("Sprite2D/VBoxContainer")
	if start_screen_buttons:
		start_screen_buttons.visible = true

func _on_volume_music_value_changed(value):
	changeMusic(value)

func _on_volume_effekts_value_changed(value):
	changeSFX(value)
