extends Node

@export var music_volume_db: float = 0 
@onready var audio_music = $AudioStreamPlayer2D 
@onready var audio_sfx = $ButtonPlayer
var defaultpath = null

func _input(event):
	if event is InputEventMouseButton:
		Settings.load_settings()
		print(Settings.sfx)
		play_button()


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
	else:
		if(audio_music.playing):
			audio_music.volume_db = volume_db / 7.5
		elif(defaultpath != null):
			play_music(defaultpath)
			

func set_sfx(volume_db: float):
	if(volume_db <= 1.0):
		audio_sfx.stop()
	else:
		if(audio_sfx.playing):
			audio_sfx.volume_db = volume_db / 7.5
		else:
			play_button()

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
	if stream and Settings.sfx >1.0:
		audio_sfx.stream = stream
		audio_sfx.play()

func play_scrap():
	var stream = ResourceLoader.load("res://Sounds/scrapCollected.wav")
	if stream and Settings.sfx >1.0:
		audio_sfx.stream = stream
		audio_sfx.play()
		
func play_repair():
	var stream = ResourceLoader.load("res://Sounds/Repairshop.wav")
	if stream and Settings.sfx >1.0:
		audio_sfx.stream = stream
		audio_sfx.play()
func play_repairshop():
	var stream = ResourceLoader.load("res://Sounds/Repairshop.wav")
	if (stream):
		audio_sfx.stream = stream
		audio_sfx.play()
