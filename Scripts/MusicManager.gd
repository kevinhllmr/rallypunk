extends Node

@export var music_volume_db: float = 0  # Default volume
@onready var audio_player = $AudioStreamPlayer2D  # Reference to the audio player node
var defaultpath = null


func play_music(stream_path: String):
	defaultpath = stream_path
	var stream = load_music(stream_path)
	if stream:
		audio_player.stream = stream
		audio_player.play()
	

func stop_music():
	audio_player.stop()


func set_volume(volume_db: float):
	if(volume_db <= 1.0):
		stop_music()
	else:
		if(!audio_player.has_stream_playback()):
			play_music("res://Sounds/Menu.wav")
	audio_player.volume_db = volume_db / 7.5

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
		



func _on_audio_stream_player_2d_finished():
	play_music(defaultpath)
	print("Replay Music")
	
func play_button():
	var stream = load_music("res://Sounds/buttonClick.wav")
	if stream:
		audio_player.stream = stream
		audio_player.play()
