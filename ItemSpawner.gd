extends Path3D

func _ready():
	spawn_items()

#func spawn_items():
	#var curve = get_curve()  # Access the curve property of the Path3D node
#
	#for i in range(curve.get_point_count()):
		#var point_position = curve.get_point_position(i)
		#spawn_item(point_position)
#
#func spawn_item(position):
	#var item_scene = load("res://items/item.tscn")
	#var item_instance = item_scene.instantiate()
	#item_instance.global_transform.origin = position
	#add_child(item_instance)

var MIN_DISTANCE = 20
var MAX_DISTANCE = 100
var MAX_OFFSET = 5


func spawn_items():
	var curve = get_curve()
	var points = curve.get_baked_points()

	var current_distance = 0
	var total_distance = curve.get_baked_length()

	while current_distance < total_distance:
		var distance_to_next_item = randf_range(MIN_DISTANCE, MAX_DISTANCE)
		current_distance += distance_to_next_item

		var offset = Vector3(randf_range(-MAX_OFFSET, MAX_OFFSET), 0, randf_range(-MAX_OFFSET, MAX_OFFSET))

		var position = get_position_from_distance(points, current_distance)
		position += offset

		spawn_item(position)

func get_position_from_distance(points, distance):
	var accumulated_distance = 0
	var last_point = points[0]

	for i in range(1, points.size()):
		var current_point = points[i]
		var segment_distance = last_point.distance_to(current_point)

		if accumulated_distance + segment_distance >= distance:
			var remaining_distance = distance - accumulated_distance
			var t = remaining_distance / segment_distance
			var interpolated_position = last_point + (current_point - last_point) * t
			return interpolated_position

		accumulated_distance += segment_distance
		last_point = current_point

	return points[-1]

func spawn_item(position):
	var item_scene = load("res://items/item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.global_transform.origin = position
	add_child(item_instance)
