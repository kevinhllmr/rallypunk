extends Node

@export var music_volume_db: float = 0  # Default volume
@onready var audio_player = $AudioStreamPlayer2D  # Reference to the audio player node

func _ready():
	# Optional: Start playing music on ready
	play_music("res://path/to/your/music/file.ogg")

func play_music(stream_path: String):
	var stream = load_music(stream_path)
	if stream:
		audio_player.stream = stream
		audio_player.play()

func stop_music():
	audio_player.stop()

func set_volume(volume_db: float):
	audio_player.volume_db = volume_db

func fade_out_music(duration: float):
	# Use a timer or Tween to gradually decrease volume over 'duration'
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", -80, duration)  # -80 dB for fade-out

func load_music(stream_path: String) -> AudioStream:
	var stream = ResourceLoader.load(stream_path)
	if stream and stream is AudioStream:
		return stream
	else:
		print("Error loading audio stream: " + stream_path)
		return null
