class_name Enemy_Jump
extends CharacterBody2D

signal muerte_jump

const EnemyRun = 70
const Gravedad = 98

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit: CollisionShape2D = $AnimatedSprite2D/Hitbox/hit
@onready var hurt: CollisionShape2D = $AnimatedSprite2D/Hurtbox/hurt

func _ready():
	velocity.x = EnemyRun
	animated_sprite_2d.play("Run_Enemy")

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

func take_damage(damage):
	Debug.log("Auch %d" % damage)
	animated_sprite_2d.play("Death_Enemy")
	muerte_jump.emit()
	hit.queue_free()
	hurt.queue_free()
	collision_layer = 0
	collision_mask  = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	await animated_sprite_2d.animation_finished
	queue_free()
