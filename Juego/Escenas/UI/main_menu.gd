extends Control

@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var controls: Button = %Controls
@onready var botones: AudioStreamPlayer = $Botones
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var return_button: Button = $Panel/ReturnButton
@onready var panel: Panel = $Panel

func _ready() -> void:
	start_button.disabled = false
	controls.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false
	panel.visible = false
	animation_r.play("Retry")
	return_button.pressed.connect(_on_return_button_pressed)
	start_button.pressed.connect(_on_start_pressed)
	controls.pressed.connect(_on_controls_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
func _on_return_button_pressed():
	botones.play()
	panel.visible = false
	
func _on_start_pressed():
	start_button.disabled = true
	controls.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/juego.tscn")
	
func _on_controls_pressed():
	panel.visible = true
	start_button.disabled = true
	controls.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	get_tree().create_timer(0.4).timeout
	start_button.disabled = false
	controls.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false

func _on_credits_pressed():
	start_button.disabled = true
	controls.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/creditos.tscn")

func _on_quit_pressed():
	start_button.disabled = true
	controls.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await get_tree().create_timer(0.6).timeout
	await botones.finished
	get_tree().quit()
