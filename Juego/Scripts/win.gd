extends Control

@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit


func _ready() -> void:
	menu.pressed.connect(_on_menu_pressed)
	quit.pressed.connect(func(): get_tree().quit())

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
