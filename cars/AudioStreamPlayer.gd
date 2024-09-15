extends Node

@onready var idle_sound = $Idle
@onready var offlow_sound = $offlow
@onready var onlow_sound = $onlow

var current_speed = 0.0
var max_speed = 100.0
var acceleration = 10.0
var deceleration = 5.0
var is_accelerating = false

var volume_db = Settings.sfx
func _ready():
	Settings.load_settings()  # Load settings
func _physics_process(delta):
	
	if Settings.sfx <= 1.0:
		_stop_all()
		volume_db = (Settings.sfx-90)/4
		pass
	else:
		volume_db = (Settings.sfx-90)/4
		if Input.is_action_pressed("ui_up"):
			_accelerate(delta)
		elif Input.is_action_pressed("ui_down"):
			_decelerate(delta)
		else:
			_idle()

	# Adjust sounds based on speed
		_handle_sound()

		_update_volume(volume_db)

# Accelerate the car
func _accelerate(delta):
	is_accelerating = true
	current_speed = min(current_speed + acceleration * delta, max_speed)

# Decelerate the car
func _decelerate(delta):
	is_accelerating = false
	current_speed = max(current_speed - deceleration * delta, 0)

# Handle idle state
func _idle():
	if current_speed > 0:
		_decelerate(1 / 60)  # Natural deceleration
	else:
		current_speed = 0
		is_accelerating = false

# Handle sound transitions and dynamic pitch scaling
func _handle_sound():
	var speed_ratio = current_speed / max_speed  # Ratio of current speed to max speed
	
	# Adjust pitch dynamically based on speed
	idle_sound.pitch_scale = 1.0 + speed_ratio * 0.2  # Idle pitch slightly changes with speed
	onlow_sound.pitch_scale = 1.0 + speed_ratio * 0.5  # Low throttle pitch increases with speed
	offlow_sound.pitch_scale = 1.0 + speed_ratio * 0.3  # Off throttle sound also adjusts

	# Fade volumes for smooth transitions
	var fade_duration = 0.1  # Seconds for fade duration
	if current_speed == 0:
		# Play idle sound
		if not idle_sound.is_playing():
			_stop_all()
			idle_sound.play()
	elif is_accelerating:
		# Play low on-throttle sound (onlow)
		if not onlow_sound.is_playing():
			_stop_all()
			onlow_sound.play()
	else:
		# Play off-throttle sound
		if not offlow_sound.is_playing():
			_stop_all()
			offlow_sound.play()

	# Smooth volume fading based on state
	if idle_sound.is_playing():
		idle_sound.volume_db = lerp(idle_sound.volume_db, volume_db, fade_duration)
	if onlow_sound.is_playing():
		onlow_sound.volume_db = lerp(onlow_sound.volume_db, volume_db, fade_duration)
	if offlow_sound.is_playing():
		offlow_sound.volume_db = lerp(offlow_sound.volume_db, volume_db, fade_duration)

# Stop all sounds
func _stop_all():
	idle_sound.stop()
	offlow_sound.stop()
	onlow_sound.stop()

# Adjust sound volume
func _update_volume(volume_db):
	idle_sound.volume_db = volume_db
	offlow_sound.volume_db = volume_db
	onlow_sound.volume_db = volume_db
