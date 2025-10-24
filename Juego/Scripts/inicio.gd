extends Control

@onready var animation_r: AnimationPlayer = $Retry_Anim/Animation_R
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	animation_r.play("Retry")
	await animation_r.animation_finished
	animation_player.play("Inicio")
	await get_tree().create_timer(0.5).timeout
	audio_stream_player.play()
	await animation_player.animation_finished
	animation_r.play_backwards("Retry")
	await animation_r.animation_finished
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")
