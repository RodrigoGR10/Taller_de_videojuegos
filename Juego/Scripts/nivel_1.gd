extends Node2D

@onready var player: Player = $Player
@onready var enemy_ghost: Enemy_Ghost = $Enemy_Ghost
@onready var enemy_jump: Enemy_Jump = $Enemy_Jump
@onready var enemy_jump_3: Enemy_Jump = $Enemy_Jump3
@onready var enemy: Enemy = $Enemy
@onready var enemy_ghost_2: Enemy_Ghost = $Enemy_Ghost2
@onready var enemy_jump_2: Enemy_Jump = $Enemy_Jump2

func _ready() -> void:
	enemy.muerte.connect(_on_body_contact)
	enemy_jump.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_2.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_jump_3.muerte_jump.connect(_on_jump_enemy_contact)
	enemy_ghost.muerte_ghost.connect(_on_body_ghost_contact)
	enemy_ghost_2.muerte_ghost.connect(_on_body_ghost_contact)

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
