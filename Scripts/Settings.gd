extends Node2D
var resolution = 0
var volume = 100

func _ready():
	setUP()

func setUP():
	load_settings()
	changeResolution(resolution)
	changeVolume(volume)
	
func _on_option_button_item_selected(index):
	changeResolution(index)

func _on_h_slider_value_changed(value):
	print(value)
	changeVolume(value)

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
	#$MarginContainer/VBoxContainer/OptionButton.selected(index)
func changeVolume(value):
	var slider = $MarginContainer/VBoxContainer/HSlider
	volume = value
	print(volume)
	if(slider):
		slider.value = value
		MusicManager.set_volume(value)
	save_settings()

func save_settings():
	var save_data = {
		"resolution": resolution,
		"volume": volume,
	}
	var save_file = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_settings():
	if FileAccess.file_exists("user://settings.dat"):
		var save_file = FileAccess.open("user://settings.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		resolution = save_data["resolution"]
		volume = save_data["volume"]
	else:
		# For testing, set the scrap to 1000 if no save file exists
		resolution = 2
		volume = 100
		
func show_menu(visible: bool):
	self.visible = visible


func _on_close_pressed():
	self.visible = false
	var start_screen_buttons = get_parent().get_node("Sprite2D/VBoxContainer")
	if start_screen_buttons:
		start_screen_buttons.visible = true
