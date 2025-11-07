class_name Credits
extends Control

@onready var main_menu_return: Button = $"Retry_Anim/Main Menu Return"
@onready var quit: Button = $Retry_Anim/Quit
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var ButtonSound: AudioStream

func _ready() -> void:
	AudioManager.start_music()
	main_menu_return.disabled = false
	quit.disabled = false
	animation_r.play("Retry")
	animation_player.play("Créditos")
	await animation_r.animation_finished
	main_menu_return.pressed.connect(_on_main_menu_return_pressed)
	quit.pressed.connect(_on_quit_pressed)
	await animation_player.animation_finished
	await get_tree().create_timer(0.8).timeout
	animation_r.play_backwards("Retry")
	animation_player.play("Letras")

func _on_main_menu_return_pressed() -> void:
	main_menu_return.disabled = true
	quit.disabled = true
	AudioManager.play_sfx(ButtonSound)
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.go_to_main_menu()

func _on_quit_pressed() -> void:
	main_menu_return.disabled = true
	quit.disabled = true
	AudioManager.play_sfx(ButtonSound)
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()
