extends AudioStreamPlayer

@onready var car = $".."
@onready var gear = $"../Hud/Gear"

var current_gear = 1
var max_gears = 5
var is_accelerating = false
var gear_shift_timer = 0.0  # Timer to control the brief pause for gear shift
var gear_shift_pause_duration = 0.03  # Duration of the pause in seconds

func _physics_process(delta):
	Settings.load_settings()
	volume_db = Settings.sfx
	var factor = 0.6
	var constant = 0
	var speed = car.speed * factor
	print(volume_db)
	# Determine the gear based on speed
	var new_gear = clamp(floor(speed / 3) + 1, 1, max_gears)  # Divide speed to determine gear, clamp between 1 and max_gears
	
	# Check for gear change and initiate a brief pause
	if new_gear != current_gear:
		current_gear = new_gear
		gear.text = str(current_gear)
		gear_shift_timer = gear_shift_pause_duration  # Start the pause timer
		stop()  # Stop playback to simulate gear shift pause

	# Adjust pitch scale for the sound
	if current_gear > 1:  # Prevent division by zero for the first gear
		pitch_scale = constant + speed / (5 * (current_gear - 1))  # Dynamic pitch scaling
	else:
		pitch_scale = constant

	# Smooth volume change with proper type conversion
	if(volume_db <= 1.0):
		stop()
	else:
		play()
		if Input.is_action_pressed("ui_up"):
			volume_db = (lerp(volume_db, float(-20), 0.1)/ 7.5)-20  # Gradually increase volume
		else:
			volume_db = (lerp(volume_db, float(-30), 0.05)/7.5)-20 # Gradually decrease volume
	
	# Handle gear shift pause and resume playback
	if gear_shift_timer > 0:
		gear_shift_timer -= delta
		if gear_shift_timer <= 0 && volume_db>=1.0:
			play()  # Resume playback after pause
	else:
		if not is_playing() and volume_db>=1.0:
			play()
