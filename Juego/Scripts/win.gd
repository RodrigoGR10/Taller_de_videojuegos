extends Control

@onready var menu: Button = $PanelContainer/MarginContainer/VBoxContainer/Menu
@onready var next_level: Button = $PanelContainer/MarginContainer/VBoxContainer/Next_Level
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var botones: AudioStreamPlayer = $Botones

func _ready() -> void:
	animation_r.play("Retry")
	await animation_r.animation_finished
	menu.pressed.connect(_on_menu_pressed)
	next_level.pressed.connect(_on_next_level_pressed)
	quit.pressed.connect(_on_quit_pressed)

func _on_menu_pressed():
	menu.disabled = true
	next_level.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")
	
func _on_next_level_pressed():
	menu.disabled = true
	next_level.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")

func _on_quit_pressed():
	menu.disabled = true
	next_level.disabled = true
	quit.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
