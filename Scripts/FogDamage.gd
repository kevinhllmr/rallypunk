extends Area3D

var message_timer : Timer
var is_car_in_fog = false
var car_node : VehicleBody3D = null

func _ready():
	# Create and configure the Timer node
	message_timer = Timer.new()
	add_child(message_timer)
	message_timer.wait_time = 1.0  # Set the timer interval to 1 second
	message_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	# Connect signals using Callable
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("car"):
		print("Auto ist in den Sturm hinein gefahren")
		is_car_in_fog = true
		car_node = body
		message_timer.start()  # Start the timer to print message every 1 second

func _on_body_exited(body):
	if body.is_in_group("car"):
		print("Auto ist aus dem Sturm heraus gefahren")
		is_car_in_fog = false
		car_node = null
		message_timer.stop()  # Stop the timer when the car exits the fog

func _on_timer_timeout():
	if is_car_in_fog:
		if car_node.get_chassis_health() > 0:
			print("Auto befindet sich im Sturm. ChassisHealth: -5")
			car_node.set_chassis_health(car_node.get_chassis_health() - 5)
		else:
			print("Auto befindet sich im Sturm. EngineHealth: -10")
			car_node.set_engine_health(car_node.get_engine_health() - 10)
