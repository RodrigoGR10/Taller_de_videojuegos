class_name Enemy_Ghost
extends CharacterBody2D

signal muerte_ghost
signal colisión_jugador

@export var count = 1
@export var max_speed:float = 80
@export var jump_speed:float = 400
@export var gravity:float = 600
@export var acceleration:float = 300

var dead = false

@export var DeathSound: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $Pivot/AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $Pivot/AnimatedSprite2D/Hurtbox/hurt
@onready var timer: Timer = $Timer
@onready var area_2d: Area2D = $Pivot/Area2D
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D
@onready var choque: CollisionShape2D = $Pivot/Area2D/Choque

func _ready():
	choque.disabled = true
	animated_sprite_2d.play("Run_Enemy")
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	var move_input = pivot.scale.x
	velocity.x = move_toward(velocity.x, move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if ray_cast_2d.is_colliding() and ray_cast_2d.enabled:
		pivot.scale.x *= -1

func _on_timer_timeout():
	if dead:
		return
	if count % 2 == 0:
		count += 1
		animated_sprite_2d.modulate.a = 0.4
		collision_layer = 0
		collision_mask = 0
		hit.disabled = true
		hurt.disabled = true
		set_collision_layer_value(6, true)
		set_collision_mask_value(6, true)
		ray_cast_2d.set_collision_mask_value(6, true)
		choque.disabled = true
		timer.start()
	else:
		animated_sprite_2d.modulate.a = 1
		count += 1
		collision_layer = 0
		collision_mask = 0
		if hit != null and is_instance_valid(hit):
			hit.disabled = false
		if hurt != null and is_instance_valid(hurt):
			hurt.disabled = false
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		ray_cast_2d.set_collision_mask_value(1, true)
		choque.disabled = false
		timer.start()

func take_damage(damage):
	if dead:
		return
	dead = true
	Debug.log("Auch %d" % damage)
	if choque != null and is_instance_valid(choque):
		var area := choque.get_parent()
		if area and is_instance_valid(area):
			area.set_deferred("monitoring", false)
			area.set_deferred("monitorable", false)
		choque.set_deferred("disabled", true)
	if timer != null:
		timer.stop()
		if timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.disconnect(_on_timer_timeout)
	if hit != null and is_instance_valid(hit):
		hit.set_deferred("disabled", true)
	if hurt != null and is_instance_valid(hurt):
		hurt.set_deferred("disabled", true)
	animated_sprite_2d.play("Death_Enemy")
	muerte_ghost.emit()
	if hit != null and is_instance_valid(hit):
		hit.queue_free()
		hit = null
	if hurt != null and is_instance_valid(hurt):
		hurt.queue_free()
		hurt = null
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	AudioManager.play_sfx(DeathSound)
	await animated_sprite_2d.animation_finished
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		colisión_jugador.emit()
