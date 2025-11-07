extends CanvasLayer

@export var ButtonSound: AudioStream

@onready var continue_button: Button = %ContinueButton
@onready var controls: Button = %Controls
@onready var audio_settings: Button = %AudioSettings
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton
@onready var return_button: Button = $Controls_Panel/ReturnButton
@onready var return_button_2: Button = $Audio_Panel/ReturnButton_2
@onready var controls_panel: Panel = $Controls_Panel
@onready var audio_panel: Panel = $Audio_Panel
@onready var music: HSlider = $Audio_Panel/Music
@onready var sfx: HSlider = $Audio_Panel/Sfx

func _ready() -> void:
	controls_panel.visible = false
	audio_panel.visible = false
	continue_button.pressed.connect(_on_continue_pressed)
	controls.pressed.connect(_on_controls_pressed)
	audio_settings.pressed.connect(_on_audio_settings_pressed)
	main_menu_button.pressed.connect(_on_MainMenu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	return_button.pressed.connect(_on_return_button_pressed)
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
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		controls_panel.visible = false
		audio_panel.visible = false
		continue_button.disabled = false
		controls.disabled = false
		audio_settings.disabled = false
		main_menu_button.disabled = false
		quit_button.disabled = false
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_return_button_pressed():
	AudioManager.play_sfx(ButtonSound)
	controls_panel.visible = false
	audio_panel.visible = false
		
func _on_continue_pressed():
	continue_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	visible = false
	get_tree().paused = false
	
func _on_controls_pressed():
	controls_panel.visible = true
	continue_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	get_tree().create_timer(0.4).timeout
	continue_button.disabled = false
	controls.disabled = false
	audio_settings.disabled = false
	main_menu_button.disabled = false
	quit_button.disabled = false
	
func _on_audio_settings_pressed():
	audio_panel.visible = true
	continue_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	get_tree().create_timer(0.4).timeout
	continue_button.disabled = false
	controls.disabled = false
	audio_settings.disabled = false
	main_menu_button.disabled = false
	quit_button.disabled = false
	
func _on_MainMenu_pressed():
	continue_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	AudioManager.play_sfx(ButtonSound)
	visible = false
	get_tree().paused = false
	LevelManager.go_to_main_menu()
	
func _on_quit_pressed():
	continue_button.disabled = true
	controls.disabled = true
	audio_settings.disabled = true
	main_menu_button.disabled = true
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
