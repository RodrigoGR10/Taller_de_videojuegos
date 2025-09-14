class_name Player
extends CharacterBody2D

@export var max_speed = 200
@export var jump_speed = 300
@export var gravity = 600
@export var acceleration = 380

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var body: Sprite2D = $Pivote/Body
@onready var playback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Pivot

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = -jump_speed

	# Movimiento horizontal
	var move_input = Input.get_axis("Move_left", "Move_right")
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)

	# Aplicar movimiento
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
		
