class_name Player
extends CharacterBody2D

@export var max_speed:float = 150
@export var jump_speed:float = 400
@export var gravity:float = 600
@export var acceleration:float = 300

@export var heal:float = 3
@export var run:bool = false
@export var run_count:float = 0
@export var extra_jump:bool = false
@export var jump_count:float = 0
@export var count_visible:float = 0
@export var Visible:bool = false
@export var was_on_floor:bool = true
@export var floor:bool = false

var special_active: bool = false

@export var JumpSound: AudioStream
@export var DañoSound: AudioStream

@export var dust_particles_scene: PackedScene

@onready var mage: Sprite2D = $Pivot/Mage
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var pivot: Node2D = $Pivot
@onready var collision_shape_2d: CollisionShape2D = $Pivot/Mage/Hitbox/CollisionShape2D
@onready var hitbox: Area2D = $Pivot/Mage/Hitbox
@onready var collision_shape_player: CollisionShape2D = $CollisionShapePlayer
@onready var vida_jugador: Label = $Puntuacion/Vida_Jugador
@onready var heart: Sprite2D = $Puntuacion/Heart
@onready var heart_2: Sprite2D = $Puntuacion/Heart2
@onready var heart_3: Sprite2D = $Puntuacion/Heart3
@onready var hit: CollisionShape2D = $Pivot/Mage/Hitbox/hit
@onready var hurt: CollisionShape2D = $Pivot/Mage/Hurtbox/hurt
@onready var static_body_2d: StaticBody2D = $"../StaticBody2D"
@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $Puntuacion/ProgressBar
@onready var retry_anim: Node2D = $Camera2D/Retry_Anim
@onready var color_rect: ColorRect = $Puntuacion/Retry_Anim/ColorRect
@onready var animation_r: AnimationPlayer = $Puntuacion/Retry_Anim/Animation_R
@onready var camera_2d: Camera2D = $Camera2D
@onready var c_f: CollisionShape2D = $Colision_Fantasma/C_F
@onready var dust_spawn: Marker2D = $DustSpawn
@onready var jump_hud: Sprite2D = $Puntuacion/MarginContainer/PanelContainer/Jump_hud
@onready var invisibility_hub: Sprite2D = $Puntuacion/MarginContainer/PanelContainer/invisibility_hub
@onready var run_hud: Sprite2D = $Puntuacion/MarginContainer/PanelContainer/run_hud

@onready var poder_acum_1: MarginContainer = $Puntuacion/PoderAcum1
@onready var poder_acum_2: MarginContainer = $Puntuacion/PoderAcum2
@onready var poder_acum_3: MarginContainer = $Puntuacion/PoderAcum3


func _ready() -> void:
	animation_r.play("Retry")
	c_f.disabled = true
	progress_bar.visible = false
	Debug.log(static_body_2d.collision_layer)
	Engine.time_scale = 1
	jump_hud.visible = false
	invisibility_hub.visible = false
	run_hud.visible = false
	timer.timeout.connect(_on_timer_timeout)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Retry"):
		animation_r.play_backwards("Retry")
		await animation_r.animation_finished
		get_tree().reload_current_scene()
	if not is_on_floor():
		velocity.y += gravity * delta
		if was_on_floor == true and jump_count != 0 and extra_jump == true and Input.is_action_just_pressed("saltar"):
			was_on_floor = false
			velocity.y = 0
			await get_tree().create_timer(0.01).timeout
			velocity.y = -jump_speed
			jump_count -= 1
			AudioManager.play_sfx(JumpSound)
			if jump_count == 0:
				extra_jump = false
				jump_hud.visible = false
				poder_acum_1.modulate = Color.WHITE
				poder_acum_2.modulate = Color.WHITE
				poder_acum_3.modulate = Color.WHITE
				Debug.log("No more jumps")
			
			if jump_count == 1:
				poder_acum_2.modulate = Color.WHITE
			if jump_count == 2:
				poder_acum_3.modulate = Color.WHITE
	else:
		was_on_floor = true
		
	if Input.is_action_just_pressed("bajar"):
		velocity.y = +jump_speed/4
		
	if Visible == true and Input.is_action_just_pressed("Especial") and count_visible != 0 and not special_active:
		special_active = true
		mage.modulate.a = 0.4
		collision_layer = 0
		collision_mask  = 0
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)
		hit.disabled = true
		hurt.disabled = true
		c_f.disabled = true
		progress_bar.value = 100
		progress_bar.visible = true
		timer.start()
		await get_tree().create_timer(2).timeout
		c_f.disabled = false
		await get_tree().create_timer(0.2).timeout
		c_f.disabled = true
		progress_bar.visible = false
		count_visible -= 1
		mage.modulate.a = 1
		hit.disabled = false
		hurt.disabled = false
		collision_layer = 0
		collision_mask  = 0
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		if count_visible == 0:
			Visible = false
			invisibility_hub.visible = false
			poder_acum_1.modulate = Color.WHITE
			poder_acum_2.modulate = Color.WHITE
			poder_acum_3.modulate = Color.WHITE
		
		if count_visible == 1:
			poder_acum_2.modulate = Color.WHITE
		if count_visible == 2:
			poder_acum_3.modulate = Color.WHITE
		special_active = false
		
	if is_on_floor() and run == true and run_count != 0 and Input.is_action_just_pressed("Especial") and not special_active:
		special_active = true
		max_speed = 400
		progress_bar.value = 100
		progress_bar.visible = true
		timer.start()
		await get_tree().create_timer(2).timeout
		progress_bar.visible = false
		run_count -= 1
		if run_count == 0:
			run = false
			run_hud.visible = false
			poder_acum_1.modulate = Color.WHITE
			poder_acum_2.modulate = Color.WHITE
			poder_acum_3.modulate = Color.WHITE
			Debug.log("No more runs")
		if run_count == 1:
			poder_acum_2.modulate = Color.WHITE
		if run_count == 2:
			poder_acum_3.modulate = Color.WHITE
		max_speed = 150
		Debug.log(run_count)
		special_active = false
		
	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = -jump_speed
		AudioManager.play_sfx(JumpSound)
		
	var move_input = Input.get_axis("mover_izquierda","mover_derecha")
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if is_on_floor() and not floor:
		spawn_dust()
	
	floor = is_on_floor()
	
	if move_input:
		pivot.scale.x = sign(move_input)
	if is_on_floor():
		if move_input or abs(velocity.x) > 10:
			playback.travel("Run")
		else:
			playback.travel("Idle")
	else:
		if velocity.y < 0:
			playback.travel("Jump")
			
		else:
			playback.travel("Fall")
	
	if heal <= 0:
		playback.travel("muerte_animation")
		
func take_damage(damage):
	camera_2d.apply_shake()
	AudioManager.play_sfx(DañoSound)
	velocity.x = -max_speed/2
	velocity.y = -jump_speed/3
	heal -= damage
	if(heal == 2):
		heart_3.visible = false
	elif (heal == 1):
		heart_2.visible = false
	if heal <= 0:
		heart.visible = false
		Engine.time_scale = 0.5
		var tree = get_tree()
		animation_r.play_backwards("Retry")
		await animation_r.animation_finished
		tree.change_scene_to_file("res://Escenas/game_over.tscn")
		
		
func _on_timer_timeout():
	progress_bar.value -= 10


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		velocity.y -= 100
		animation_r.play_backwards("Retry")
		await animation_r.animation_finished
		get_tree().reload_current_scene()

func _on_win_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_r.play_backwards("Retry")
		await animation_r.animation_finished
		if LevelManager.levels.size() > LevelManager.current_level + 1:
			get_tree().change_scene_to_file("res://Escenas/win.tscn")
		else:
			LevelManager.go_to_credits()

func _on_colision_fantasma_body_entered(body: Node2D) -> void:
	if body is Enemy or body is Enemy_Ghost or body is Enemy_Jump or body is Paredes_invisibles:
		position.x -= 60
		take_damage(1)
		
func spawn_dust():
	if not dust_particles_scene:
		return
	var dust_particles_inst = dust_particles_scene.instantiate()
	add_child(dust_particles_inst)
	dust_particles_inst.global_position = dust_spawn.global_position
