class_name Level_3
extends Node2D

var Palanca = false

@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var enemy_2: Enemy = $Enemy2
@onready var enemy_3: Enemy = $Enemy3
@onready var enemy_4: Enemy = $Enemy4
@onready var enemy_5: Enemy = $Enemy5
@onready var enemy_6: Enemy = $Enemy6
@onready var enemy_jump: Enemy_Jump = $Enemy_Jump
@onready var enemy_jump_2: Enemy_Jump = $Enemy_Jump2
@onready var enemy_jump_3: Enemy_Jump = $Enemy_Jump3
@onready var enemy_jump_4: Enemy_Jump = $Enemy_Jump4

@onready var enemy_ghost: Enemy_Ghost = $Enemy_Ghost
@onready var enemy_ghost_2: Enemy_Ghost = $Enemy_Ghost2
@onready var plataforma: AnimatedSprite2D = $Plataforma_Salto/Plataforma

@onready var centro_7: TileMapLayer = $Centro7
@onready var centro_8: TileMapLayer = $Centro8
@onready var centro_9: TileMapLayer = $Centro9
@onready var centro_10: TileMapLayer = $Centro10

@onready var collision_7: CollisionShape2D = $Centro7/Daño/Collision7
@onready var collision_8: CollisionShape2D = $Centro8/Daño/Collision8
@onready var collision_9: CollisionShape2D = $Centro9/Daño/Collision9
@onready var collision_10: CollisionShape2D = $Centro10/Daño/Collision10

@onready var jump_sound: AudioStreamPlayer2D = $Plataforma_Salto/Jump_Sound

func _ready() -> void:
	LevelManager.current_level = 2
	Debug.log(LevelManager.current_level)
	AudioManager.start_music()
	enemy.muerte.connect(_on_body_contact)
	enemy_2.muerte.connect(_on_body_contact)
	enemy_3.muerte.connect(_on_body_contact)
	enemy_4.muerte.connect(_on_body_contact)
	enemy_5.muerte.connect(_on_body_contact)
	enemy_6.muerte.connect(_on_body_contact)
	enemy_jump.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_2.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_3.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_4.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_ghost.muerte_ghost.connect(_on_body_ghost_contact)
	enemy_ghost_2.muerte_ghost.connect(_on_body_ghost_contact)
	enemy_ghost.colisión_jugador.connect(_empuje)
	enemy_ghost_2.colisión_jugador.connect(_empuje)

func _on_body_ghost_contact():
	player.velocity.y = -player.jump_speed/3
	player.Visible = true
	player.invisibility_hub.visible = true
	
	
	player.run = false
	player.run_hud.visible = false
	
	player.extra_jump = false
	player.jump_hud.visible = false
	player.count_visible += 1
	Debug.log("Visible:" + str(player.visible))
	Debug.log("Visible:" + str(player.count_visible))
	if player.run_count != 0:
		player.run_count = 0
	if player.jump_count != 0:
		player.jump_count = 0
		
	if player.count_visible == 1:
		player.poder_acum_1.modulate = Color(3.39, 10.431, 0.0)
	if player.count_visible == 2:
		player.poder_acum_2.modulate = Color(3.39, 10.431, 0.0)
	if player.count_visible == 3:
		player.poder_acum_3.modulate = Color(3.39, 10.431, 0.0)
	
func _on_body_contact():
	player.velocity.y = -player.jump_speed/3
	player.run = true
	player.run_hud.visible = true
	
	player.Visible = false
	player.invisibility_hub.visible = false
	
	player.extra_jump = false
	player.jump_hud.visible = false
	player.run_count += 1
	Debug.log("Run:" + str(player.run))
	Debug.log("Extra runs:" + str(player.run_count))
	if player.jump_count != 0:
		player.jump_count = 0
	if player.count_visible != 0:
		player.count_visible = 0

	if player.run_count == 1:
		player.poder_acum_1.modulate = Color(3.39, 10.431, 0.0)
	if player.run_count == 2:
		player.poder_acum_2.modulate = Color(3.39, 10.431, 0.0)
	if player.run_count == 3:
		player.poder_acum_3.modulate = Color(3.39, 10.431, 0.0)
	
func _on_jump_enemy_contact():
	player.velocity.y = -player.jump_speed/3
	player.extra_jump = true
	player.jump_hud.visible = true
	
	player.run = false
	player.run_hud.visible = false
	
	player.Visible = false
	player.invisibility_hub.visible = false
	player.jump_count += 1
	Debug.log("Double jump:" + str(player.extra_jump))
	Debug.log("Extra jump:" + str(player.jump_count))
	if player.count_visible != 0:
		player.count_visible = 0
	if player.run_count != 0:
		player.run_count = 0
	
	if player.jump_count == 1:
		player.poder_acum_1.modulate = Color(3.39, 10.431, 0.0)
	if player.jump_count == 2:
		player.poder_acum_2.modulate = Color(3.39, 10.431, 0.0)
	if player.jump_count == 3:
		player.poder_acum_3.modulate = Color(3.39, 10.431, 0.0)
		
		
func _empuje():
	player.position.x -= 60
	player.take_damage(1)

func _on_plataforma_salto_body_entered(body: Node2D) -> void:
	if body is Player:
		jump_sound.play()
		plataforma.play()
		player.velocity.y = -player.jump_speed*2.5

func _on_daño_body_entered(body: Node2D) -> void:
	var A = get_tree()
	if body is Player:
		player.animation_r.play_backwards("Retry")
		await player.animation_r.animation_finished
		LevelManager.retry_level()
		if centro_7:
			collision_7.disabled = true
			centro_7.queue_free()
		if centro_8:
			collision_8.disabled = true
			centro_8.queue_free()
		if centro_9:
			collision_9.disabled = true
			centro_9.queue_free()
		if centro_10:
			collision_10.disabled = true
			centro_10.queue_free()
