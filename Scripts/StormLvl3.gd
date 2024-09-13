extends Path3D

func _process(delta):
	$PathFollow3D.progress += 17.5*delta
