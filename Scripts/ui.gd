extends Node


@onready var pause_menu = $PauseMenu
@onready var car_hud = $car/Hud
var paused = false

func _process(delta):
	distanceFog()
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		var buttons = $PauseMenu/VBoxContainer
		$PauseMenu/Settings.show_menu(false)
		buttons.visible=true

func distanceFog():
	var fog_volume = $Path3D2/PathFollow3D
	var player = $car
	var dist = fog_volume.position - player.position
	dist = dist.length()
	var loading_bar = $car/Hud/ProgressBar
	var slider = $car/Hud/VSlider
	#print (dist)
	#loading_bar.value = 100-(dist/3) + 50
	loading_bar.value = fog_volume.progress_ratio * 100
	
	var start_pos = $Start.position
	var end_pos = $FinishLine.position
	var total_distance = start_pos.distance_to(end_pos)
	var player_pos = player.global_position
	var distance_to_player = start_pos.distance_to(player_pos)
	var progress_ratio = clamp(distance_to_player / total_distance, 0.0, 1.0)

	slider.value = progress_ratio * slider.max_value
	#print("Player progress:", progress_ratio * 100, "%")
	
	#print(fog_volume.progress_ratio*100)




func pauseMenu(): 
	if paused:
		pause_menu.hide()
		car_hud.show()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		car_hud.hide()
		Engine.time_scale = 0
	paused = !paused
