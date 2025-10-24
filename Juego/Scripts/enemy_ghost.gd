class_name Enemy_Ghost
extends CharacterBody2D

signal muerte_ghost
signal colisión_jugador

@export var EnemyRun = 70
@export var Gravedad = 98
@export var count = 1

var dead = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $AnimatedSprite2D/Hurtbox/hurt
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var choque: CollisionShape2D = $Area2D/Choque

func _ready():
	velocity.x = EnemyRun
	choque.disabled = true
	animated_sprite_2d.play("Run_Enemy")
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta):
	if dead:
		return
	velocity.y += Gravedad
	
	if is_on_wall():
		if animated_sprite_2d.flip_h:
			velocity.x = EnemyRun
		else:
			velocity.x = -EnemyRun
		
		if velocity.x < 0:
			animated_sprite_2d.flip_h = true
		elif velocity.x > 0:
			animated_sprite_2d.flip_h = false 
		
	move_and_slide()

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
	audio_stream_player_2d.play()
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.visible = false
	await get_tree().create_timer(1.2).timeout
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		colisión_jugador.emit()
