extends AudioStreamPlayer


@onready var car = $".."
@onready var gear = $"../Hud/Gear"


func _physics_process(delta):
	var factor = 0.6
	var constant = 0.5
	if car.speed <= 20 * factor:
		gear.text = "1"
		pitch_scale = constant+car.speed/5
	if car.speed >= 20 * factor:
		gear.text = "2"
		pitch_scale = constant+car.speed/20
	if car.speed >= 30 * factor:
		gear.text = "3"
		pitch_scale = constant+car.speed/30
	if car.speed >= 50 * factor:
		gear.text = "4"
		pitch_scale = constant+car.speed/40
	if car.speed >= 70 * factor:
		gear.text = "5"
		pitch_scale = constant+car.speed/50
	if car.speed >= 100 * factor:
		gear.text = "6"
		pitch_scale = constant+car.speed/60
		
	if Input.is_action_pressed("ui_up"):
		volume_db = 0
	else:
		volume_db = -3
