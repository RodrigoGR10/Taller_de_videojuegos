class_name MainMenu
extends Control

@export var ButtonSound: AudioStream

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var controls: Button = %Controls
@onready var audio_settings: Button = %AudioSettings
@onready var return_button_2: Button = $Audio_Panel/ReturnButton_2
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var return_button: Button = $Controls_Panel/ReturnButton
@onready var controls_panel: Panel = $Controls_Panel
@onready var audio_panel: Panel = $Audio_Panel
@onready var music: HSlider = $Audio_Panel/Music
@onready var sfx: HSlider = $Audio_Panel/Sfx

func _ready() -> void:
	AudioManager.start_music()
	controls_panel.visible = false
	audio_panel.visible = false
	start_button.disabled = false
	controls.disabled = false
	audio_settings.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false
	animation_r.play("Retry")
	return_button.pressed.connect(_on_return_button_pressed)
	start_button.pressed.connect(_on_start_pressed)
	controls.pressed.connect(_on_controls_pressed)
	audio_settings.pressed.connect(_on_audio_settings_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	return_button_2.pressed.connect(_on_return_button_pressed)
	music.min_value = -80
	music.max_value = 0
	sfx.min_value = -80
	sfx.max_value = 0
	music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	sfx.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx"))
	music.value_changed.connect(_on_music_slider_changed)
	sfx.value_changed.connect(_on_sfx_slider_changed)
	return_button_2.pressed.connect(_on_return_button_pressed)
	
func _on_return_button_pressed():
	AudioManager.play_sfx(ButtonSound)
	controls_panel.visible = false
	audio_panel.visible = false
	
func _on_start_pressed():
	start_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.current_level = -1
	LevelManager.go_to_next_level()
	
func _on_controls_pressed():
	controls_panel.visible = true
	start_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	get_tree().create_timer(0.4).timeout
	start_button.disabled = false
	controls.disabled = false
	audio_settings.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false

func _on_audio_settings_pressed():
	audio_panel.visible = true
	start_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	get_tree().create_timer(0.4).timeout
	start_button.disabled = false
	controls.disabled = false
	audio_settings.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false

func _on_credits_pressed():
	start_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.go_to_credits()

func _on_quit_pressed():
	start_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()
	
func _on_music_slider_changed(value: float) -> void:
	var bus_idx := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, value)

func _on_sfx_slider_changed(value: float) -> void:
	var bus_idx := AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(bus_idx, value)
