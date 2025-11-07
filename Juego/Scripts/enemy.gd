class_name Enemy
extends CharacterBody2D

signal muerte

@export var count = 1
@export var max_speed:float = 80
@export var jump_speed:float = 400
@export var gravity:float = 600
@export var acceleration:float = 300

@export var DeathSound: AudioStream

@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $Pivot/AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $Pivot/AnimatedSprite2D/Hurtbox/hurt
@onready var timer: Timer = $Timer

var is_boost: bool = false

func _ready():
	animated_sprite_2d.play("Run_Enemy")
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var move_input = pivot.scale.x
	var effective_speed: float
	if is_boost:
		effective_speed = max_speed * 3.4
	else:
		effective_speed = max_speed
	velocity.x = move_toward(velocity.x, move_input * effective_speed, acceleration * delta)
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1
	move_and_slide()
	
func _on_timer_timeout():
	if count % 2 == 0:
		is_boost = true
		count += 1
	else:
		is_boost = false
		count += 1
	timer.start()

func take_damage(damage):
	Debug.log("Auch %d" % damage)
	animated_sprite_2d.play("Death_Enemy")
	AudioManager.play_sfx(DeathSound)
	muerte.emit()
	hit.queue_free()
	hurt.queue_free()
	collision_layer = 0
	collision_mask  = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	await animated_sprite_2d.animation_finished
	queue_free()
