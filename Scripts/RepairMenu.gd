extends Panel

@onready var notenoughscrap = $VBC/MarginContainerV2/NotEnoughScrap

var all_cost = 0
var chassis_cost = 0
var wheels_cost = 0
var brakes_cost = 0
var engine_cost = 0

func _ready():
	hide()
	notenoughscrap.visible = false

func _process(delta):
	update_values()
	update_cost()

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
		if car.remove_scrap(all_cost):
			car.engine_health = 100
			car.chassis_health = 100
			car.wheels_health = 100
			car.brake_health = 100
		else:
			notEnough()


func _on_buy_1_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(chassis_cost):
			car.chassis_health = 100
		else:
			notEnough()
		
func _on_buy_2_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(wheels_cost):
			car.wheels_health = 100
		else:
			notEnough()


func _on_buy_3_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(brakes_cost):
			car.brake_health = 100
		else:
			notEnough()


func _on_buy_4_pressed():
	var car = get_parent()
	if car:
		if car.remove_scrap(engine_cost):
			car.engine_health = 100
		else:
			notEnough()

func update_cost():	
	var car = get_parent()
	
	var buy1 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer2/BuyC/Buy1
	var cost1 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer2/CostC/Cost
	var ch = car.chassis_health

		
	if ch == 100:
		buy1.visible = false
		cost1.visible = false
	else:
		buy1.visible = true
		cost1.visible = true
		
	if ch < 100 && ch >= 75:
		chassis_cost = 1
		
	if ch < 75 && ch >= 50:
		chassis_cost = 2
		
	if ch < 50 && ch >= 25:
		chassis_cost = 3
		
	if ch < 25:
		chassis_cost = 4
	
	cost1.text = str(chassis_cost) + " S"
	
		
	var buy2 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer3/BuyC/Buy2
	var cost2 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer3/CostC/Cost
	var wh = car.wheels_health
	
	if wh == 100:
		buy2.visible = false
		cost2.visible = false
	else:
		buy2.visible = true
		cost2.visible = true
		
	if wh < 100 && wh >= 75:
		wheels_cost = 1
		
	if wh < 75 && wh >= 50:
		wheels_cost = 2
		
	if wh < 50 && wh >= 25:
		wheels_cost = 3
		
	if wh < 25:
		wheels_cost = 4
		
	cost2.text = str(wheels_cost) + " S"
	
		
	var buy3 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer4/BuyC/Buy3
	var cost3 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer4/CostC/Cost
	var bh = car.brake_health
	
	if bh == 100:
		buy3.visible = false
		cost3.visible = false
	else:
		buy3.visible = true
		cost3.visible = true
		
	if bh < 100 && bh >= 75:
		brakes_cost = 1
		
	if bh < 75 && bh >= 50:
		brakes_cost = 2
		
	if bh < 50 && bh >= 25:
		brakes_cost = 3
		
	if bh < 25:
		brakes_cost = 4
		
	cost3.text = str(brakes_cost) + " S"
	
	
	var buy4 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer5/BuyC/Buy4
	var cost4 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer5/CostC/Cost
	var eh = car.engine_health
	
	if eh == 100:
		buy4.visible = false
		cost4.visible = false
	else: 
		buy4.visible = true
		cost4.visible = true
		
	if eh < 100 && eh >= 75:
		engine_cost = 1
		
	if eh < 75 && eh >= 50:
		engine_cost = 2
		
	if eh < 50 && eh >= 25:
		engine_cost = 3
		
	if eh < 25:
		engine_cost = 4
			
	cost4.text = str(engine_cost) + " S"
	
	var allcost_label = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer/CostC/Cost
	all_cost = chassis_cost + wheels_cost + brakes_cost + engine_cost
	if car.chassis_health >= 100 && car.wheels_health >= 100 && car.brake_health >= 100 && car.engine_health >= 100:
		all_cost = 0
	allcost_label.text = str(all_cost) + " S"
	
func update_values():
	var car = get_parent()
	$VBC/ShopContainer/PercentagesC/Wheels.text = "Wheels: " + str(round(car.wheels_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Chassis.text = "Chassis: " + str(round(car.chassis_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Brakes.text = "Brakes: " + str(round(car.brake_health)) + "%"
	$VBC/ShopContainer/PercentagesC/Motor.text = "Engine: " + str(round(car.engine_health)) + "%"
