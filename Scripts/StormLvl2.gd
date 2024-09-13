extends Path3D

func _process(delta):
	$PathFollow3D.progress += 20.0*delta
