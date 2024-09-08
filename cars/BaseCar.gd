extends VehicleBody3D

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var engine_health = 100
var brake_health = 100
var chassis_health = 100
var wheels_health = 100
var engine_degradation = 0.0005
var brake_degradation = 0.003
var wheels_degradation = 0.003

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
	
	var surface_type = null;
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		surface_type = collider.name
		#print(surface_type)
	
	$Hud/speed.text=str(round(speed*3.6))+"  KMPH"
	$Hud/engine.text="Motor: " + str(round(engine_health)) +"%"
	$Hud/brake.text="Bremsen: " + str(round(brake_health)) +"%"
	$Hud/chassis.text = "Chassis: " + str(round(chassis_health)) + "%"
	$Hud/wheels.text = "Räder: " + str(round(wheels_health)) + "%"
	var fwd_mps = -linear_velocity.dot(transform.basis.z)
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	
	if Input.is_action_pressed("ui_down"):
		print("fwd_mps: ",fwd_mps)
	# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= 1:
			brake = 1 * (round(brake_health)/100)
			#Schaden für Bremsen
			brake_health = brake_health-(brake_degradation*speed)
			if brake_health < 0:
				brake_health = 0
			#print(brake_health)
		else:
			if surface_type != "off-road":
				engine_force = clamp(engine_force_value * 3 / speed, 0, 300)*(round(engine_health)/100)
			else:
				engine_force = clamp(engine_force_value / speed, 0, 20)*(round(engine_health)/100)
			#Schaden für Motor
			engine_health = engine_health-(engine_degradation*speed)
			if engine_health < 0:
				engine_health = 0
			#print(engine_health)
	else:
		if not Input.is_action_just_pressed("ui_select"):
			brake = 0
		
	if Input.is_action_pressed("ui_up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				if surface_type != "off-road":
					engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)*(round(engine_health)/100)
				else:
					engine_force = -clamp(engine_force_value * 3 / speed, 0, 30)*(round(engine_health)/100)
			else:
				engine_force = -clamp(engine_force_value * 1 / speed, 0, 30)*(round(engine_health)/100)
			#Schaden für Motor
			engine_health = engine_health-(engine_degradation*speed)
			if engine_health < 0:
				engine_health = 0
			#print(engine_health)
		else:
			brake = 1 * (round(brake_health)/100)
			#Schaden für Bremsen
			brake_health = brake_health-(brake_degradation*speed)
			if brake_health < 0:
				brake_health = 0
			#print(brake_health)

	else:
		if not Input.is_action_pressed("ui_down"):
			engine_force = 0
		
	if Input.is_action_pressed("ui_select"):
		brake=3
		$wheal2.wheel_friction_slip=0.2 + 0.6 * (round(wheels_health)/100)
		$wheal3.wheel_friction_slip=0.2 + 0.6 * (round(wheels_health)/100)
		#Schaden für Räder wenn Handbremse gezogen wird, vllt lieber noch ne Geschwindigkeitsabfrage machen (oder linearer Geschwindigkeit sonst Abtrag in der Luft)
		wheels_health = wheels_health-(wheels_degradation*speed)
		if wheels_health < 0:
			wheels_health = 0
	else:
		$wheal2.wheel_friction_slip=0.5 + 2.5 * (round(wheels_health)/100)
		$wheal3.wheel_friction_slip=0.5 + 2.5 * (round(wheels_health)/100)
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func traction(speed):
	apply_central_force(Vector3.DOWN*speed)

func _integrate_forces(state):
	var current_velocity = state.get_linear_velocity()
	var collision_impact = (current_velocity - last_velocity).length()
	if collision_impact > 2.77:  # 10 km/h in m/s
		apply_damage(collision_impact)
	last_velocity = current_velocity

# Aufgerufen wenn Kollision auftritt
func _on_body_shape_entered(body_id, body, body_shape, area_shape):
	if speed > 10:
		apply_damage(speed)
#Schadensanwendung für Kollisionen, erst Schaden an Chassis, dann geht alles auf Motor
func apply_damage(impact):
	var damage = (impact / 2)
	chassis_health -= damage
	if chassis_health < 0:
		chassis_health = 0
		engine_health -= damage
		if engine_health < 0:
			engine_health = 0
	#print("Geschwindigkeit: ", speed)
	#print("Kollisionskraft: ", impact)
	#print("Chassis Schaden: ", damage)

func get_speed() -> float:
	return linear_velocity.length()
	
func set_chassis_health(value: int):
	chassis_health = clamp(value, 0, 100)
	#print("ChassisHealth updated: ", chassis_health)

func get_chassis_health() -> int:
	return chassis_health
	
func set_engine_health(value: int):
	engine_health = clamp(value, 0, 100)
	#print("EngineHealth updated: ", engine_health)

func get_engine_health() -> int:
	return engine_health

func pick_up_scrap():
	scrap_count += 1
	update_scrap_count()
	
func get_scrap_count() -> int:
	return scrap_count
	
func update_scrap_count():
	if scrap_count_label:
		scrap_count_label.text = "Scrap: " + str(scrap_count)

func remove_scrap(change_amount):
	if !scrap_count - change_amount < 0:
		scrap_count = scrap_count - change_amount
		scrap_count_label.text = "Scrap: " + str(scrap_count)
		get_node("RepairShopPanel").get_node("VBC").get_node("ScrapCount").text = "Scrap: " + str(get_scrap_count())
		print("used " + str(change_amount) + " scrap to repair car!")
	else:
		print("not enough scrap!")


