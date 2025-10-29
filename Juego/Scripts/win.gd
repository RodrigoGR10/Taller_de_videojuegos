extends Control

@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var next_level: Button = $PanelContainer/MarginContainer/VBoxContainer/Next_Level
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var botones: AudioStreamPlayer = $Botones

func _ready() -> void:
	animation_r.play("Retry")
	await animation_r.animation_finished
	next_level.pressed.connect(_on_next_level_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _on_next_level_pressed():
	next_level.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.go_to_next_level()

func _on_menu_pressed():
	next_level.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.go_to_main_menu()

func _on_quit_pressed():
	next_level.disabled = true
	menu.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
