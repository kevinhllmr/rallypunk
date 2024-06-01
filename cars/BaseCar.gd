extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
var scrap_count: int = 0
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
	var speed = linear_velocity.length()
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"

	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("ui_down"):
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
	if Input.is_action_pressed("ui_up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		brake=3
		$wheal2.wheel_friction_slip=2
		$wheal3.wheel_friction_slip=2
	else:
		$wheal2.wheel_friction_slip=4
		$wheal3.wheel_friction_slip=4
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

func traction(speed):
	apply_central_force(Vector3.DOWN*speed)
	
func get_speed() -> float:
	return linear_velocity.length()

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
