extends Control

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var botones: AudioStreamPlayer = $Botones
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R

func _ready() -> void:
	animation_r.play("Retry")
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
func _on_start_pressed():
	start_button.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/juego.tscn")

func _on_credits_pressed():
	start_button.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/creditos.tscn")

func _on_quit_pressed():
	start_button.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	await animation_r.animation_finished
	get_tree().quit()
