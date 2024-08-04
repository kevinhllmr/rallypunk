extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var engine_health = 100
var brake_health = 100


<<<<<<< Updated upstream
func _physics_process(delta):
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"
	$Hud/engine.text="Engine: " + str(round(engine_health)) +"%"
	$Hud/brake.text="Brake: " + str(round(brake_health)) +"%"
=======

var scrap_count_label: Label = null

func _ready():
	# Ensure the VehicleBody3D node has an Area3D as a child for detecting collisions
	var area = $CollisionArea  # Adjust the path to your Area3D node
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("car")
	
	scrap_count_label = get_node("Hud/ScrapCount")
func _on_body_entered(body):
	if body is StaticBody3D:
		print("Collision with: ", body.name)
		
func _physics_process(delta):
	speed = linear_velocity.length()
	Playerstats.time = float(Playerstats.time) + delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.6))+"  KM/H"
	$Hud/engine.text="Motor: " + str(round(engine_health)) +"%"
	$Hud/brake.text="Bremsen: " + str(round(brake_health)) +"%"
	$Hud/chassis.text = "Chassis: " + str(round(chassis_health)) + "%"
	$Hud/wheels.text = "Räder: " + str(round(wheels_health)) + "%"
	update_ui()
>>>>>>> Stashed changes
	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("ui_down"):
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 3 / speed, 0, 300)
			brake_health = brake_health-(0.004*speed)
			
			print(brake_health)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
	if Input.is_action_pressed("ui_up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)
				engine_health = engine_health-(0.004*speed)
				print(engine_health)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		brake=3
		$wheal2.wheel_friction_slip=0.8
		$wheal3.wheel_friction_slip=0.8
	else:
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	apply_central_force(Vector3.DOWN*speed)




<<<<<<< Updated upstream
=======
func pick_up_scrap():
	Playerstats.scrap_count += 1
	update_scrap_count()
	
func get_scrap_count() -> int:
	return Playerstats.scrap_count
	
func update_scrap_count():
	if scrap_count_label:
		scrap_count_label.text = str(Playerstats.scrap_count)

func remove_scrap(change_amount):
	if !Playerstats.scrap_count - change_amount < 0:
		Playerstats.scrap_count = Playerstats.scrap_count - change_amount
		scrap_count_label.text = str(Playerstats.scrap_count)
		get_node("RepairShopPanel").get_node("VBC").get_node("ScrapCount").text = "Scrap: " + str(get_scrap_count())
		print("used " + str(change_amount) + " scrap to repair car!")
	else:
		print("not enough scrap!")
		
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func update_ui():
	# Format time with two decimal places
	var formatted_time = str(Playerstats.time)
	var decimal_index = formatted_time.find(".")
	
	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 2)  # Take only two decimal places
		$Hud/time.text = formatted_time
	
	

>>>>>>> Stashed changes
