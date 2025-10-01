class_name Player
extends CharacterBody2D

@export var max_speed = 150
@export var jump_speed = 400
@export var gravity = 600
@export var acceleration = 300

@export var heal = 3
@export var run = false
@export var run_count = 0
@export var extra_jump = false
@export var jump_count = 0
@export var count_visible = 0
@export var Visible = false
@export var was_on_floor = true

@onready var mage: Sprite2D = $Pivot/Mage
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var pivot: Node2D = $Pivot
@onready var collision_shape_2d: CollisionShape2D = $Pivot/Mage/Hitbox/CollisionShape2D
@onready var hitbox: Area2D = $Pivot/Mage/Hitbox
@onready var muerte: AudioStreamPlayer2D = $Muerte
@onready var collision_shape_player: CollisionShape2D = $CollisionShapePlayer
@onready var enemy: Enemy = $"../Enemy"
@onready var vida_jugador: Label = $Puntuacion/Vida_Jugador
@onready var enemy_ghost: Enemy_Ghost = $"../Enemy_Ghost"
@onready var hit: CollisionShape2D = $Pivot/Mage/Hitbox/hit
@onready var hurt: CollisionShape2D = $Pivot/Mage/Hurtbox/hurt
@onready var static_body_2d: StaticBody2D = $"../StaticBody2D"
@onready var enemy_jump: Enemy_Jump = $"../Enemy_Jump"
@onready var enemy_jump_2: Enemy_Jump = $"../Enemy_Jump2"
@onready var enemy_ghost_2: Enemy_Ghost = $"../Enemy_Ghost2"
@onready var enemy_jump_3: Enemy_Jump = $"../Enemy_Jump3"

func _ready() -> void:
	Debug.log(static_body_2d.collision_layer)
	Engine.time_scale = 1
	enemy.muerte.connect(_on_body_contact)
	enemy_jump.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_2.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_3.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_ghost.muerte_ghost.connect(_on_body_ghost_contact)
	enemy_ghost_2.muerte_ghost.connect(_on_body_ghost_contact)
	
func _on_body_ghost_contact():
	velocity.y = -jump_speed/3
	Visible = true
	run = false
	extra_jump = false
	count_visible += 1
	Debug.log("Visible:" + str(visible))
	Debug.log("Visible:" + str(count_visible))
	if run_count != 0:
		run_count = 0
	if jump_count != 0:
		jump_count = 0
	
func _on_body_contact():
	velocity.y = -jump_speed/3
	run = true
	Visible = false
	extra_jump = false
	run_count += 1
	Debug.log("Run:" + str(run))
	Debug.log("Extra runs:" + str(run_count))
	if jump_count != 0:
		jump_count = 0
	if count_visible != 0:
		count_visible = 0
	
func _on_jump_enemy_contact():
	velocity.y = -jump_speed/3
	extra_jump = true
	run = false
	Visible = false
	jump_count += 1
	Debug.log("Double jump:" + str(extra_jump))
	Debug.log("Extra jump:" + str(jump_count))
	if count_visible != 0:
		count_visible = 0
	if run_count != 0:
		run_count = 0
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if was_on_floor == true and jump_count != 0 and extra_jump == true and Input.is_action_just_pressed("saltar"):
			was_on_floor = false
			velocity.y = 0
			await get_tree().create_timer(0.01).timeout
			velocity.y = -jump_speed
			jump_count -= 1
			if jump_count == 0:
				extra_jump = false
				Debug.log("No more jumps")
			Debug.log(jump_count)
	else:
		was_on_floor = true
		
	if Input.is_action_just_pressed("bajar"):
		velocity.y = +jump_speed/4
		
	if Visible == true and Input.is_action_just_pressed("Especial") and mage.visible == true and count_visible != 0:
		mage.visible = false
		collision_layer = 0
		collision_mask  = 0
		set_collision_layer_value(4, true)
		set_collision_mask_value(4, true)
		hit.disabled = true
		hurt.disabled = true
		await get_tree().create_timer(2).timeout
		count_visible -= 1
		mage.visible = true
		hit.disabled = false
		hurt.disabled = false
		collision_layer = 0
		collision_mask  = 0
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		if count_visible == 0:
			Visible = false
		
	if is_on_floor() and run == true and run_count != 0 and Input.is_action_just_pressed("Especial"):
		max_speed = 400
		await get_tree().create_timer(2).timeout
		run_count -= 1
		if run_count == 0:
			run = false
			Debug.log("No more runs")
		max_speed = 150
		Debug.log(run_count)
		
	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = -jump_speed
		
	var move_input = Input.get_axis("mover_izquierda","mover_derecha")
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
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
	velocity.x = -max_speed/2
	velocity.y = -jump_speed/3
	heal -= damage
	vida_jugador.text = str(heal)
	if heal <= 0:
		Engine.time_scale = 0.5
		await get_tree().create_timer(0.2).timeout
		get_tree().reload_current_scene()
