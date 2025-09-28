extends Control

@onready var main_menu_return: Button = $"Main Menu Return"
@onready var quit: Button = $Quit


func _ready() -> void:
	main_menu_return.pressed.connect(_on_main_menu_return_pressed)
	quit.pressed.connect(_on_quit_pressed)

func _on_main_menu_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
