class_name Enemy_Jump
extends CharacterBody2D

signal muerte_jump

@export var count = 1
@export var max_speed:float = 80
@export var jump_speed:float = 400
@export var gravity:float = 600
@export var acceleration:float = 300

@export var DeathSound: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $Pivot/AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $Pivot/AnimatedSprite2D/Hurtbox/hurt
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D

var phase_time: float = 0.0
var walking: bool = true

func _ready():
	animated_sprite_2d.play("Run_Enemy")

func _physics_process(delta: float) -> void:
	phase_time += delta
	if walking:
		if phase_time >= 1.2:
			phase_time = 0.0
			walking = false
			count += 1
			animated_sprite_2d.play("Idle_Enemy")
	else:
		if phase_time >= 1.2:
			phase_time = 0.0
			walking = true
			count += 1
			animated_sprite_2d.play("Run_Enemy")

	if not is_on_floor():
		velocity.y += gravity * delta
	var move_input = pivot.scale.x
	if walking:
		velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
	move_and_slide()
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1


func take_damage(damage):
	Debug.log("Auch %d" % damage)
	hit.queue_free()
	hurt.queue_free()
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	animated_sprite_2d.play("Death_Enemy")
	muerte_jump.emit()
	AudioManager.play_sfx(DeathSound)
	await get_tree().create_timer(0.2).timeout
	animated_sprite_2d.visible = false
	queue_free()
