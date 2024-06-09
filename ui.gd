extends Node

func _process(delta):
	distanceFog()
	
	
	
	
func distanceFog():
	var fog_volume = $Path3D/PathFollow3D
	var player = $car
	var dist = fog_volume.position - player.position
	dist = dist.length()
	var loading_bar = $car/Hud/ProgressBar
	print (dist)
	loading_bar.value = 100-dist/3+5
