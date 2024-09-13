extends Node2D

@onready var notenoughscrap = $VBC/MarginContainerV2/NotEnoughScrap
@onready var player_data = get_node("Playerstats") 
@onready var scrap_count_label = $VBC/TitlebarContainer/ScrapCount  

var upgrade_save_file_path: String = "user://upgrades_data.save"
var upgrades: Dictionary = {}
var available_upgrades = {
	"traction": false,
	"traction_2": false,
	"scrap_multiplier_2": false,
	"better_chassis": false,
	"better_engine": false,
	"off-road": false,
}

func _ready():
	notenoughscrap.visible = false
	self.visible = false
	load_upgrades()

func show_menu(visible: bool):
	self.visible = visible
	if visible:
		_on_upgrade_menu_visible()

func _on_upgrade_menu_visible():
	if visible:
		player_data.load_game_data()
		print_player_data()		
		update_upgrade_menu_ui()
		check_upgrade_button()

func print_player_data():
	print("Player Data:")
	print("Scrap: ", player_data.scrap)
	print("XP: ", player_data.xp)
	print("Collected Scrap: ", player_data.collectedScrap)
	print("Collected XP: ", player_data.collectedXP)
	print("Rank: ", player_data.rank)
	print("Total XP: ", player_data.totalXP)

func update_upgrade_menu_ui():
	if scrap_count_label:
		scrap_count_label.text = "Scrap: " + str(player_data.scrap)
	else:
		print("ScrapCount node not found in UpgradeMenu")

func check_upgrade_button():
	var upgrade1 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer2/BuyC/Buy1
	var upgrade1c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer2/CostC/Cost
	if has_upgrade("traction"): 
		if upgrade1:
			upgrade1.visible = false
			upgrade1c.visible = false
			
	var upgrade2 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer3/BuyC/Buy2
	var upgrade2c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer3/CostC/Cost
	if has_upgrade("traction_2"): 
		if upgrade2:
			upgrade2.visible = false
			upgrade2c.visible = false
			
	var upgrade3 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer4/BuyC/Buy3
	var upgrade3c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer4/CostC/Cost
	if has_upgrade("scrap_multiplier_2"): 
		if upgrade3:
			upgrade3.visible = false
			upgrade3c.visible = false
			
	var upgrade4 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer5/BuyC/Buy4
	var upgrade4c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer5/CostC/Cost
	if has_upgrade("off-road"): 
		if upgrade4:
			upgrade4.visible = false
			upgrade4c.visible = false
			
	var upgrade5 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer6/BuyC/Buy5
	var upgrade5c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer6/CostC/Cost
	if has_upgrade("better_chassis"): 
		if upgrade5:
			upgrade5.visible = false
			upgrade5c.visible = false
			
	var upgrade6 = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer7/BuyC/Buy6
	var upgrade6c = $VBC/ShopContainer/ScrollContainer/VBoxContainer/ItemContainer7/CostC/Cost
	if has_upgrade("better_engine"): 
		if upgrade6:
			upgrade6.visible = false
			upgrade6c.visible = false

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

func _on_close_pressed():
	# Hide the upgrade menu
	self.visible = false
	
	# Show the start screen buttons again
	var start_screen_buttons = get_parent().get_node("Sprite2D/VBoxContainer")
	if start_screen_buttons:
		start_screen_buttons.visible = true
	else:
		print("Start screen buttons node not found.")

func _on_buy_1_pressed():
	var upgrade_cost = 10  
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("traction"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("traction") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 1 purchased! Remaining scrap: ", player_data.scrap)
	
func _on_buy_2_pressed():
	var upgrade_cost = 25
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("traction_2"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("traction_2") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 2 purchased! Remaining scrap: ", player_data.scrap)

func _on_buy_3_pressed():
	var upgrade_cost = 30  
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("scrap_multiplier_2"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("scrap_multiplier_2") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 3 purchased! Remaining scrap: ", player_data.scrap)
	
func _on_buy_4_pressed():
	var upgrade_cost = 50 
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("off-road"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("off-road") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 4 purchased! Remaining scrap: ", player_data.scrap)
	
func _on_buy_5_pressed():
	var upgrade_cost = 35 
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("better_chassis"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("better_chassis") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 5 purchased! Remaining scrap: ", player_data.scrap)

func _on_buy_6_pressed():
	var upgrade_cost = 40
	player_data.load_game_data()
	var player_scrap = player_data.scrap 
	
	if player_scrap < upgrade_cost:
		notEnough()
		return
		
	if has_upgrade("better_engine"):
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost 
	unlock_upgrade("better_engine") 

	save_upgrades()
	player_data.save_game_data()

	update_upgrade_menu_ui()

	check_upgrade_button()

	print("Upgrade 6 purchased! Remaining scrap: ", player_data.scrap)

func save_upgrades():
	var save_file = FileAccess.open(upgrade_save_file_path, FileAccess.WRITE)
	if save_file:
		var json_string = JSON.stringify(upgrades)
		save_file.store_string(json_string)
		print("Upgrades saved successfully.")
	else:
		print("Failed to save upgrades.")

func load_upgrades():
	if not FileAccess.file_exists(upgrade_save_file_path):
		print("No save file found. Initializing with default upgrades.")
		upgrades = available_upgrades.duplicate()
		save_upgrades()
		return

	var save_file = FileAccess.open(upgrade_save_file_path, FileAccess.READ)
	if save_file:
		var json_string = save_file.get_as_text()

		var json = JSON.new()
		var parse_result = json.parse(json_string)

		if parse_result == OK:
			upgrades = json.get_data()
			print("Upgrades loaded: ", upgrades)
		else:
			print("Failed to load upgrades: ", json.get_error_message())
	else:
		print("Error reading the upgrades save file.")

func has_upgrade(upgrade_name: String) -> bool:
	return upgrades.get(upgrade_name, false)

func unlock_upgrade(upgrade_name: String):
	if available_upgrades.has(upgrade_name):
		upgrades[upgrade_name] = true
		save_upgrades() 
		print(upgrade_name, " unlocked!")
	else:
		print("Upgrade not found:", upgrade_name)
