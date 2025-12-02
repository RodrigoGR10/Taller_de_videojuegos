extends TileMapLayer

@onready var bloques: Area2D = $Bloques
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Player = $"../Player"

func _on_bloques_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		animation_player.play("Caer")
		await animation_player.animation_finished
		await get_tree().create_timer(0.2).timeout
		queue_free()

func _on_daño_body_entered(body: Node2D) -> void:
	var A = get_tree()
	if body is Player:
		player.collision_layer = 0
		player.collision_mask = 0
		player.animation_r.play_backwards("Retry")
		await player.animation_r.animation_finished
		Debug.log("RETRY")
		LevelManager.retry_level()
