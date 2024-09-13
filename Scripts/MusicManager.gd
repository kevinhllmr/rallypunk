extends Node

@export var music_volume_db: float = 0 
@onready var audio_music = $AudioStreamPlayer2D 
@onready var audio_button = $ButtonPlayer
var defaultpath = null

func _input(event):
	if event is InputEventMouseButton:
		play_button()

func get_all_buttons(node):
	var buttons = []
	if node is Button:
		buttons.append(node)
	for child in node.get_children():
		buttons += get_all_buttons(child)
	return buttons


func play_music(stream_path: String):
	defaultpath = stream_path
	var stream = load_music(stream_path)
	if stream:
		audio_music.stream = stream
		audio_music.play()

func stop_music():
	audio_music.stop()

func set_music(volume_db: float):
	if(volume_db <= 1.0):
		stop_music()
	audio_music.volume_db = volume_db / 7.5

func set_sfx(volume_db: float):
	if(volume_db <= 1.0):
		stop_music()
	audio_button.volume_db = volume_db / 7.5

func load_music(stream_path: String) -> AudioStream:
	var stream = ResourceLoader.load(stream_path)
	if stream and stream is AudioStream:
		return stream
	else:
		print("Error loading audio stream: " + stream_path)
		return null

func _on_audio_stream_player_2d_finished():
	if defaultpath != null:
		play_music(defaultpath)
		print("Replay Music")
	
func play_button():
	var stream = ResourceLoader.load("res://Sounds/buttonClick.wav")
	if stream:
		audio_button.stream = stream
		audio_button.play()
