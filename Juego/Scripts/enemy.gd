class_name Enemy
extends CharacterBody2D

signal muerte

const Gravedad = 98
@export var count = 1
@export var EnemyRun = 70

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $AnimatedSprite2D/Hurtbox/hurt
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	velocity.x = EnemyRun
	animated_sprite_2d.play("Run_Enemy")
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta):
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
	if count % 2 == 0:
		count += 1
		if velocity.x < 0:
			velocity.x = -200
		elif velocity.x > 0:
			velocity.x = 200
		timer.start()
	else:
		count += 1
		if velocity.x < 0:
			velocity.x = -70
		elif velocity.x > 0:
			velocity.x = 70
		timer.start()

func take_damage(damage):
	Debug.log("Auch %d" % damage)
	animated_sprite_2d.play("Death_Enemy")
	audio_stream_player_2d.play()
	muerte.emit()
	hit.queue_free()
	hurt.queue_free()
	collision_layer = 0
	collision_mask  = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	await animated_sprite_2d.animation_finished
	queue_free()
