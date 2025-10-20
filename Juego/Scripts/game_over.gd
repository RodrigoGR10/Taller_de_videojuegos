extends Control

@onready var retry: Button = $PanelContainer/MarginContainer/VBoxContainer/Retry
@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	retry.pressed.connect(_on_retry_pressed)
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(func(): get_tree().quit())
	
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Escenas/game_over.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
