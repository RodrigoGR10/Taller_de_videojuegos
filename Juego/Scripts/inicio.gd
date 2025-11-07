extends Control

@export var InicioSound: AudioStream

@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_r.play("Retry")
	await animation_r.animation_finished
	animation_player.play("Inicio")
	await get_tree().create_timer(0.5).timeout
	AudioManager.play_sfx(InicioSound)
	await animation_player.animation_finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	LevelManager.go_to_main_menu()
