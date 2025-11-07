class_name GameOver
extends Control

@export var ButtonSound: AudioStream

@onready var retry: Button = $PanelContainer/MarginContainer/VBoxContainer/Retry
@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	AudioManager.start_music()
	retry.pressed.connect(_on_retry_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _on_retry_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	AudioManager.play_sfx(ButtonSound)
	LevelManager.retry_level()

func _on_menu_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	AudioManager.play_sfx(ButtonSound)
	LevelManager.go_to_main_menu()

func _on_quit_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	AudioManager.play_sfx(ButtonSound)
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()
