extends Node

@onready var main_menu: AudioStreamPlayer = $MainMenu
@onready var levels: AudioStreamPlayer = $Levels
@onready var win: AudioStreamPlayer = $Win
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var creditos: AudioStreamPlayer = $Creditos

func start_music():
	if get_tree().current_scene is MainMenu:
		levels.stop()
		win.stop()
		game_over.stop()
		creditos.stop()
		Debug.log("Main Menu")
		main_menu.play()
	if get_tree().current_scene is Credits:
		main_menu.stop()
		levels.stop()
		win.stop()
		game_over.stop()
		Debug.log("Credits")
		creditos.play()
	if get_tree().current_scene is Level_1 or get_tree().current_scene is Level_2 or get_tree().current_scene is Level_3:
		main_menu.stop()
		win.stop()
		game_over.stop()
		creditos.stop()
		Debug.log("Levels")
		levels.play()
	if get_tree().current_scene is Win:
		main_menu.stop()
		levels.stop()
		game_over.stop()
		creditos.stop()
		Debug.log("Win")
		win.play()
	if get_tree().current_scene is GameOver:
		main_menu.stop()
		levels.stop()
		win.stop()
		creditos.stop()
		Debug.log(game_over.bus)
		game_over.play()

func play_sfx(stream: AudioStream):
	if not stream:
		return
	
	var audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "Sfx"
	Debug.log(audio_stream_player.bus)
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.queue_free()
