extends Path3D

func _process(delta):
	$PathFollow3D.progress += 15.0*delta
