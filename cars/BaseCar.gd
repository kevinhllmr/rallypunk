extends VehicleBody3D

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var engine_health = 100
var brake_health = 100
var chassis_health = 100
var wheels_health = 100
var engine_degradation = 0.004
var brake_degradation = 0.004
var wheels_degradation = 0.004

var speed = 0
var last_velocity = Vector3.ZERO

var scrap_count: int = 0
var scrap_count_label: Label = null

var raycast: RayCast3D
var slowing_down = false

func _ready():
	raycast = $RayCast3D 
	raycast.enabled = true
	
	var area = $CollisionArea  # Adjust the path to your Area3D node
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("car")
	scrap_count_label = get_node("Hud/ScrapCount")

func _on_body_entered(body):
	if body is StaticBody3D:
		print("Collision with: ", body.name)
		
func _physics_process(delta):
	speed = linear_velocity.length()
	traction(speed)
	
	var surface_type = null
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		surface_type = collider.name
		print(surface_type)	
	
	$Hud/speed.text = str(round(speed * 3.6)) + " KMPH"
	$Hud/engine.text = "Motor: " + str(round(engine_health)) + "%"
	$Hud/brake.text = "Bremsen: " + str(round(brake_health)) + "%"
	$Hud/chassis.text = "Chassis: " + str(round(chassis_health)) + "%"
	$Hud/wheels.text = "Räder: " + str(round(wheels_health)) + "%"
	
	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	
	# Apply steering
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
	set_steering(steering)  # Apply the steering value to the vehicle

	var engine_force = 0.0
	var brake = 0.0
	
	if Input.is_action_pressed("ui_down"):
		# Accelerate
		if fwd_mps > 0:
			brake = 1 * (round(brake_health) / 100)
			brake_health = max(brake_health - (brake_degradation * speed), 0)
		else:
			if surface_type != "off-road":
				engine_force = clamp(engine_force_value * 3 / speed, 0, 300) * (round(engine_health) / 100)
			else:
				engine_force = clamp(engine_force_value / speed, 0, 20) * (round(engine_health) / 100)
			engine_health = max(engine_health - (engine_degradation * speed), 0)
	else:
		engine_force = 0
		
	if Input.is_action_pressed("ui_up"):
		# Brake or Reverse
		if fwd_mps >= 0:
			if speed < 30 and speed != 0:
				if surface_type != "off-road":
					engine_force = -clamp(engine_force_value * 10 / speed, 0, 300) * (round(engine_health) / 100)
				else:
					engine_force = -clamp(engine_force_value * 3 / speed, 0, 30) * (round(engine_health) / 100)
			else:
				engine_force = -engine_force_value
			engine_health = max(engine_health - (engine_degradation * speed), 0)
		else:
			brake = 1 * (round(brake_health) / 100)
			brake_health = max(brake_health - (brake_degradation * speed), 0)

	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		brake = 3
		$wheal2.wheel_friction_slip = 0.2 + 0.6 * (round(wheels_health) / 100)
		$wheal3.wheel_friction_slip = 0.2 + 0.6 * (round(wheels_health) / 100)
		wheels_health = max(wheels_health - (wheels_degradation * speed), 0)
	else:
		$wheal2.wheel_friction_slip = 0.5 + 2.5 * (round(wheels_health) / 100)
		$wheal3.wheel_friction_slip = 0.5 + 2.5 * (round(wheels_health) / 100)

	apply_engine_force(engine_force, brake)

func traction(speed):
	apply_central_force(Vector3.DOWN * speed)

func apply_engine_force(engine_force, brake):
	# Apply engine and brake forces to the vehicle
	set_brake(brake)
	set_engine_force(engine_force)

# The rest of the functions remain unchanged...
