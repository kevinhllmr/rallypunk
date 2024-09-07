extends Node


@onready var pause_menu = $PauseMenu
@onready var car_hud = $car/Hud
var paused = false

func _process(delta):
	distanceFog()
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	

func distanceFog():
	var fog_volume = $Path3D2/PathFollow3D
	var player = $car
	var dist = fog_volume.position - player.position
	dist = dist.length()
	var loading_bar = $car/Hud/ProgressBar
	#print (dist)
	loading_bar.value = 100-dist/3+5




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
