extends Control

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(func(): get_tree().quit())
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Escenas/juego.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Escenas/creditos.tscn")

func _on_quit_pressed():
	get_tree().quit()
