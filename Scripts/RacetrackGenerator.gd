extends Node3D
#
#var tileDistance = -47.8156
#var tiles = [
	#preload("res://tiles/red.glb"),
	#preload("res://tiles/blue.glb"),
	#preload("res://tiles/green.glb")
#]
#
#func _ready():
	#spawn_blocks()
#
#func spawn_blocks():
	#var spawnPosition = Vector3.ZERO
#
	#for i in range(20):  # Adjust the range as needed
		#var tileIndex = randi() % tiles.size()
		#var tileInstance = tiles[tileIndex].instantiate()
		#
		#tileInstance.global_transform.origin = spawnPosition
		#spawnPosition += Vector3(0, 0, tileDistance)
		#add_child(tileInstance)
