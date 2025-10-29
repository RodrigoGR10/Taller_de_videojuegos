extends Control

@onready var retry: Button = $PanelContainer/MarginContainer/VBoxContainer/Retry
@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var botones: AudioStreamPlayer = $Botones

func _ready() -> void:
	retry.pressed.connect(_on_retry_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _on_retry_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	LevelManager.current_level -= 1
	LevelManager.go_to_next_level()

func _on_menu_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	LevelManager.go_to_main_menu()

func _on_quit_pressed():
	retry.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
