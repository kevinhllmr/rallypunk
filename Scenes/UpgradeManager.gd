extends Node2D

@onready var notenoughscrap = $VBC/MarginContainerV2/NotEnoughScrap
@onready var player_data = get_node("Playerstats")
@onready var scrap_count_label = $VBC/TitlebarContainer/ScrapCount

var upgrade_save_file_path: String = "user://upgrades_data.save"
var upgrades: Dictionary = {}
var available_upgrades = {
	"scrap_multiplier_2": false,
	"traction_2": false,
	"engine_upgrade_2": false,
	"brake_upgrade_2": false
}

func _ready():
	notenoughscrap.visible = false
	load_upgrades()  # Load upgrades when the scene is ready
	player_data.load_game_data()  # Load player data
	print_player_data()  # Print the entire player data
	update_scrap_count()  # Update the scrap count display

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
	visible = false
	get_parent().get_node("Sprite2D/VBoxContainer").visible = true

func _on_buy_1_pressed():
	var upgrade_cost = 10

	player_data.load_game_data()
	var player_scrap = player_data.scrap 

	if player_scrap < upgrade_cost:
		notEnough()
		return

	if has_upgrade("upgrade_1"):  # Replace with the actual upgrade key
		print("Upgrade already purchased!")
		return

	player_data.scrap -= upgrade_cost
	unlock_upgrade("upgrade_1")  # Mark the upgrade as purchased

	save_upgrades()
	player_data.save_game_data()
	update_scrap_count()  # Update the scrap count display

	print("Upgrade 1 purchased! Remaining scrap: ", player_data.scrap)

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

func update_scrap_count():
	scrap_count_label.text = str(player_data.scrap)

func print_player_data():
	print("Player Data:")
	print("Scrap: ", player_data.scrap)
	print("XP: ", player_data.xp)
	print("Collected Scrap: ", player_data.collectedScrap)
	print("Collected XP: ", player_data.collectedXP)
	print("Rank: ", player_data.rank)
	print("Total XP: ", player_data.totalXP)
