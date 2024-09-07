extends Panel

@onready var notenoughscrap = $VBC/MarginContainerV2/NotEnoughScrap

func _ready():
	hide()
	notenoughscrap.visible = false

func _process(delta):
	update_values()

func _on_close_pressed():
	hide() 
	get_parent().get_node("Hud").show()
	
func notEnough():
	notenoughscrap.modulate.a = 0
	notenoughscrap.visible = true
	
	for i in range(20):
		notenoughscrap.modulate.a = i / 20.0
		await get_tree().create_timer(0.025).timeout

	await get_tree().create_timer(1.0).timeout

	for i in range(20, -1, -1):
		notenoughscrap.modulate.a = i / 20.0
		await get_tree().create_timer(0.025).timeout

	notenoughscrap.visible = false

func _on_repair_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(2):
			car.engine_health = max(car.engine_health, 100)
			car.chassis_health = max(car.chassis_health, 100)
			car.wheels_health = max(car.wheels_health, 100)
			car.brake_health = max(car.brake_health, 100)
		else:
			notEnough()


func _on_buy_1_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(2):
			car.chassis_health = car.chassis_health + 50
		else:
			notEnough()
		
func _on_buy_2_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(3):
			car.chassis_health = car.chassis_health + 50
		else:
			notEnough()


func _on_buy_3_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(5):
			car.wheels_health = car.wheels_health + 100
		else:
			notEnough()


func _on_buy_4_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(5):
			car.brake_health = car.brake_health + 100
		else:
			notEnough()


func _on_buy_5_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(7):
			car.engine_health = car.engine_health + 100
		else:
			notEnough()
			
func update_values():
	var car = get_parent()
	$VBC/ShopContainer/PercentagesC/Wheels.text = "Wheels: " + str(round(car.wheels_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Chassis.text = "Chassis: " + str(round(car.chassis_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Brakes.text = "Brakes: " + str(round(car.brake_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Motor.text = "Engine: " + str(round(car.engine_health)) + "%"
