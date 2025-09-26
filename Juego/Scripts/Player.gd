class_name Player
extends CharacterBody2D

@export var max_speed = 150
@export var jump_speed = 400
@export var gravity = 600
@export var acceleration = 300
@export var heal = 3
@export var Run = false
@export var Count = 0
@onready var mage: Sprite2D = $Mage
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
@onready var enemy_2: Enemy = $"../Enemy2"

func _ready() -> void:
	Engine.time_scale = 1
	enemy.muerte.connect(_on_body_contact)
	enemy_2.muerte.connect(_on_body_contact)

func _on_body_contact():
	Run = true
	Count += 1
	Debug.log(Count)
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("bajar"):
		velocity.y = +jump_speed/4
		
	if is_on_floor() and Run == true and Count != 0 and Input.is_action_just_pressed("Especial"):
		max_speed = 400
		await get_tree().create_timer(2).timeout
		if Count == 0:
			Run = false
		max_speed = 150
		Count -= 1
		Debug.log(Count)
		
	if is_on_floor() and Input.is_action_just_pressed("saltar"):
		velocity.y = -jump_speed
		
	if Input.is_action_just_pressed("Attack") and not animation_tree["parameters/Attack/active"]:
		animation_tree["parameters/Attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
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
