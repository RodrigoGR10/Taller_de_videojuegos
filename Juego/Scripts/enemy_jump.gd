class_name Enemy_Jump
extends CharacterBody2D

signal muerte_jump

const EnemyRun = 70
const Gravedad = 98

@export var count = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $AnimatedSprite2D/Hurtbox/hurt
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	animated_sprite_2d.play("Idle_Enemy")
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
		if animated_sprite_2d.flip_h == true:
			velocity.x = -EnemyRun
		elif animated_sprite_2d.flip_h == false:
			velocity.x = EnemyRun
		animated_sprite_2d.play("Run_Enemy")
		timer.start()
	else:
		count += 1
		velocity.x = 0
		animated_sprite_2d.play("Idle_Enemy")
		timer.start()


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
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.2).timeout
	animated_sprite_2d.visible = false
	await audio_stream_player_2d.finished
	queue_free()
