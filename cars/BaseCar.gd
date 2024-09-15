extends VehicleBody3D
@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var engine_health = 100
var brake_health = 100
var chassis_health = 100
var wheels_health = 100
var chassis_degradation = 1
var engine_degradation = 0.001
var brake_degradation = 0.003
var wheels_degradation = 0.003
var starting = true

var speed = 0
var last_velocity = Vector3.ZERO

var scrap_count: int = 0
var scrap_count_label: Label = null

var raycast: RayCast3D
var slowing_down = false

@onready var upgrade_manager = get_node("UpgradeMenu")

func _ready():
	raycast = $RayCast3D 
	raycast.enabled = true
	PlayerStats.time = 0
	PlayerStats.collectedScrap = 0
	MusicManager.set_sfx(Settings.sfx)
	MusicManager.set_music(Settings.music)
	
	var area = $CollisionArea  # Adjust the path to your Area3D node
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("car")
	scrap_count_label = get_node("Hud/ScrapCount")
	
	if upgrade_manager.has_upgrade("better_chassis"):
		chassis_degradation = 0.5
		
	if upgrade_manager.has_upgrade("better_engine"):
		engine_degradation = 0.00025
func _on_body_entered(body):
	if body is StaticBody3D:
		print("Collision with: ", body.name)

func _physics_process(delta):
	speed = linear_velocity.length()
	traction(speed)
	
	PlayerStats.time+=1
	
	var surface_type = null;
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		surface_type = collider.name
		print(surface_type)
	
	$Hud/speed.text=str(round(speed*3.6))+"  KMPH"
	$Hud/engine.text="Engine: " + str(round(engine_health)) +"%"
	$Hud/brake.text="Brakes: " + str(round(brake_health)) +"%"
	$Hud/chassis.text = "Chassis: " + str(round(chassis_health)) + "%"
	$Hud/wheels.text = "Wheels: " + str(round(wheels_health)) + "%"
	var fwd_mps = -linear_velocity.dot(transform.basis.z)
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT

	#Starting check, holds car in position until input
	if starting == true:
		linear_velocity.z = 0
		if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_select"):
			#print ("Brake unlocked")
			starting = false

	#Brake and reverse with "Down" button
	if Input.is_action_pressed("ui_down"):
		print("fwd_mps: ",fwd_mps)
		#If the car is fast enough, it will brake
		if fwd_mps >= 5 && engine_health >=20 || fwd_mps >=0 && engine_health < 20:
			brake = 1 * (round(brake_health)/100)
			#Damage for brakes
			brake_health = brake_health-(brake_degradation*speed)
			if brake_health < 0:
				brake_health = 0
			#print(brake_health)
		#Else it will accelerate (backwards)
		else:
			#Offroad check, slower acceleration if not on street
			if surface_type != "off-road" || upgrade_manager.has_upgrade("off-road"):
				engine_force = clamp(engine_force_value * 3 / speed, 0, 300)*(round(engine_health)/100)
			else:
				engine_force = clamp(engine_force_value / speed, 0, 20)*(round(engine_health)/100)
				#Damage to wheels when accelerating offroad
				wheels_health = wheels_health-(wheels_degradation*speed)
				if wheels_health < 0:
					wheels_health = 0
			#Damage for the engine when accelerating
			engine_health = engine_health-(engine_degradation*speed)
			if engine_health < 0:
				engine_health = 0
			#print(engine_health)
	#Sets brake to 0 if not used anywhere else (maybe set in physics process directly instead)
	else:
		if not Input.is_action_pressed("ui_select") && starting == false:
			brake = 0

	#Brake and accelerate with "Up" button
	if Input.is_action_pressed("ui_up"):
		#If the car is fast enough (reverse), it will brake
		if fwd_mps <= -5 && engine_health >=20 || fwd_mps <=0 && engine_health < 20:
			brake = 1 * (round(brake_health)/100)
			#Damage for brakes
			brake_health = brake_health-(brake_degradation*speed)
			if brake_health < 0:
				brake_health = 0
			#print(brake_health)
		#Else it will accelerate (2 modes)
		else:
			#Higher acceleration at lower speed (lower gear), lower acceleration on higher speed (higher gear)
			if speed < 30:
				#Offroad check, lower acceleration when not on road
				if surface_type != "off-road" || upgrade_manager.has_upgrade("off-road"):
					engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)*(round(engine_health)/100)
				else:
					engine_force = -clamp(engine_force_value * 3 / speed, 0, 30)*(round(engine_health)/100)
					#Damage to wheels when accelerating offroad
					wheels_health = wheels_health-(wheels_degradation*speed)
					if wheels_health < 0:
						wheels_health = 0
			else:
				engine_force = -clamp(engine_force_value * 1 / speed, 0, 30)*(round(engine_health)/100)
			#Damage to engine when accelerating
			engine_health = engine_health-(engine_degradation*speed)
			if engine_health < 0:
				engine_health = 0
			#print(engine_health)
	#Sets engine_force to 0 if not used anywhere else (maybe set in physics process directly instead)
	else:
		if not Input.is_action_pressed("ui_down"):
			engine_force = 0

	#Handbrake with "Spacebar", decrease friction when used and sets brake higher
	if Input.is_action_pressed("ui_select"):
		brake= 2 + 3 * (round(wheels_health)/100)
		$wheal2.wheel_friction_slip=0.2 + 0.6 * (round(wheels_health)/100)
		$wheal3.wheel_friction_slip=0.2 + 0.6 * (round(wheels_health)/100)
		#Damage for wheels when handbrake is used
		wheels_health = wheels_health-(wheels_degradation*speed)
		if wheels_health < 0:
			wheels_health = 0
	#set friction back to normal
	else:
		$wheal2.wheel_friction_slip=0.75 + 2.25 * (round(wheels_health)/100)
		$wheal3.wheel_friction_slip=0.75 + 2.25 * (round(wheels_health)/100)
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

#Upgrades for traction
func traction(speed):
	if upgrade_manager.has_upgrade("traction") && !upgrade_manager.has_upgrade("traction_2"):
		apply_central_force(Vector3.DOWN*speed*2)
		return
		
	if !upgrade_manager.has_upgrade("traction") && upgrade_manager.has_upgrade("traction_2"):
		apply_central_force(Vector3.DOWN*speed*4)
		return
		
	if upgrade_manager.has_upgrade("traction") && upgrade_manager.has_upgrade("traction_2"):
		apply_central_force(Vector3.DOWN*speed*7.5)
		return
	
	apply_central_force(Vector3.DOWN*speed)

#Checks for velocity for damage calculation, and impact
func _integrate_forces(state):
	var current_velocity = state.get_linear_velocity()
	var collision_impact = (current_velocity - last_velocity).length()
	if collision_impact > 2.77 && starting == false:  # 10 km/h in m/s
		apply_damage(collision_impact)
	last_velocity = current_velocity

#Called if there is a collision
func _on_body_shape_entered(body_id, body, body_shape, area_shape):
	if speed > 10:
		apply_damage(speed)
#Damage calculation, first damages chassis, then engine after
func apply_damage(impact):
	var damage = (impact / 2)
	chassis_health -= damage * chassis_degradation
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
	if upgrade_manager.has_upgrade("scrap_multiplier_2"):
		add_scrap(2)
	else:
		add_scrap(1)
	
func pick_up_golden_scrap():
	if upgrade_manager.has_upgrade("scrap_multiplier_2"):
		add_scrap(10)
	else:
		add_scrap(5)
	
func add_scrap(amount):
	MusicManager.play_scrap()
	scrap_count += amount
	PlayerStats.collectedScrap += amount
	PlayerStats.collectedXP += amount*100
	update_scrap_count()
	
func get_scrap_count() -> int:
	return scrap_count
	
func update_scrap_count():
	if scrap_count_label:
		scrap_count_label.text = str(scrap_count)

func remove_scrap(change_amount):
	if !scrap_count - change_amount < 0:
		scrap_count = scrap_count - change_amount
		scrap_count_label.text = str(scrap_count)
		get_node("RepairShopPanel").get_node("VBC").get_node("TitlebarContainer").get_node("ScrapCount").text = "Scrap: " + str(get_scrap_count())
		print("used " + str(change_amount) + " scrap to repair car!")
		return true

	else:
		print("not enough scrap!")
		return false

@onready var chassis_label = $Hud/chassis
@onready var brake_label = $Hud/brake
@onready var wheels_label = $Hud/wheels
@onready var engine_label = $Hud/engine

func _process(delta):
	if chassis_health == 100:
		chassis_label.label_settings.font_color = Color.WHITE
	elif chassis_health >= 75:
		chassis_label.label_settings.font_color = Color.PINK
	elif chassis_health >= 50:
		chassis_label.label_settings.font_color = Color.HOT_PINK
	elif chassis_health >= 25:
		chassis_label.label_settings.font_color = Color.DEEP_PINK
	elif chassis_health > 0:
		chassis_label.label_settings.font_color = Color.RED
	elif chassis_health == 0:
		chassis_label.label_settings.font_color = Color.BLACK

	if brake_health == 100:
		brake_label.label_settings.font_color = Color.WHITE
	elif brake_health >= 75:
		brake_label.label_settings.font_color = Color.PINK
	elif brake_health >= 50:
		brake_label.label_settings.font_color = Color.HOT_PINK
	elif brake_health >= 25:
		brake_label.label_settings.font_color = Color.DEEP_PINK
	elif brake_health > 0:
		brake_label.label_settings.font_color = Color.RED
	elif brake_health == 0:
		brake_label.label_settings.font_color = Color.BLACK

	if wheels_health == 100:
		wheels_label.label_settings.font_color = Color.WHITE
	elif wheels_health >= 75:
		wheels_label.label_settings.font_color = Color.PINK
	elif wheels_health >= 50:
		wheels_label.label_settings.font_color = Color.HOT_PINK
	elif wheels_health >= 25:
		wheels_label.label_settings.font_color = Color.DEEP_PINK
	elif wheels_health > 0:
		wheels_label.label_settings.font_color = Color.RED
	elif wheels_health == 0:
		wheels_label.label_settings.font_color = Color.BLACK

	if engine_health == 100:
		engine_label.label_settings.font_color = Color.WHITE
	elif engine_health >= 75:
		engine_label.label_settings.font_color = Color.PINK
	elif engine_health >= 50:
		engine_label.label_settings.font_color = Color.HOT_PINK
	elif engine_health >= 25:
		engine_label.label_settings.font_color = Color.DEEP_PINK
	elif engine_health > 0:
		engine_label.label_settings.font_color = Color.RED
	elif engine_health == 0:
		engine_label.label_settings.font_color = Color.BLACK


