extends AudioStreamPlayer

@onready var car = $".."
@onready var gear = $"../Hud/Gear"

var current_gear = 1
var max_gears = 5
var is_accelerating = false
var gear_shift_timer = 0.0  # Timer to control the brief pause for gear shift
var gear_shift_pause_duration = 0.03  # Duration of the pause in seconds

func _ready():
	Settings.load_settings()

func _physics_process(delta):
	volume_db = Settings.sfx - 40
	print(volume_db)
	var factor = 0.6
	var constant = 0
	var speed = car.speed * factor

	# Determine the gear based on speed
	var new_gear = clamp(floor(speed / 3) + 1, 1, max_gears)
	
	# Check for gear change and initiate a brief pause
	if new_gear != current_gear:
		current_gear = new_gear
		gear.text = str(current_gear)
		gear_shift_timer = gear_shift_pause_duration  # Start the pause timer
		stop()  # Stop playback to simulate gear shift pause

	# Adjust pitch scale for the sound
	if current_gear > 1:
		pitch_scale = constant + speed / (5 * (current_gear - 1))
	else:
		pitch_scale = constant + speed / 5  # Adjust pitch even for the first gear

	# Smooth volume change with proper type conversion
	if Input.is_action_pressed("ui_up") && volume_db >= 1.0:
		volume_db = lerp(volume_db, float(-20), 0.1)/7.5  # Gradually increase volume
	elif volume_db >= 1.0:
		volume_db = lerp(volume_db, float(-30), 0.05)/7.5  # Gradually decrease volume
	else: stop()
	# Handle gear shift pause and resume playback
	if gear_shift_timer > 0:
		gear_shift_timer -= delta
		if gear_shift_timer <= 0 and volume_db + 40 >= 1.0:
			play()  # Resume playback after pause
	else:
		if not is_playing() and volume_db + 40 >= 1.0:
			play()
			
