class_name Enemy
extends CharacterBody2D

signal muerte

const EnemyRun = 70
const Gravedad = 98

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $AnimatedSprite2D/Hurtbox/CollisionShape2D_2



func _ready():
	velocity.x = EnemyRun
	$AnimatedSprite2D.play("Run_Enemy")

func _physics_process(delta):
	velocity.y += Gravedad
	
	if is_on_wall():
		if $AnimatedSprite2D.flip_h:
			velocity.x = EnemyRun
		else:
			velocity.x = -EnemyRun
		
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false 
		
		
	move_and_slide()

func take_damage(damage):
	Debug.log("Auch %d" % damage)
	animated_sprite_2d.play("Death_Enemy")
	muerte.emit()
	await animated_sprite_2d.animation_finished
	queue_free()
