extends Control

@onready var return_button: Button = $Retry_Anim/ReturnButton
@onready var quit: Button = $Retry_Anim/Quit
@onready var audio_stream_player_2d: AudioStreamPlayer = $AudioStreamPlayer2D
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var botones: AudioStreamPlayer = $Botones

func _ready() -> void:
	return_button.disabled = false
	quit.disabled = false
	animation_r.play("Retry")
	await animation_r.animation_finished
	return_button.pressed.connect(_on_main_menu_return_pressed)
	quit.pressed.connect(_on_quit_pressed)

func _on_main_menu_return_pressed() -> void:
	return_button.disabled = true
	quit.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")

func _on_quit_pressed() -> void:
	return_button.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
