extends TileMapLayer

@export var start_delay: float = 0.5
@export var gravity: float = 800
@export var fade_after: float = 1.0

@onready var bloques: Area2D = $Bloques
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var started: bool = false
var blinking: bool = false
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not started:
		return
	await get_tree().create_timer(0.6).timeout
	velocity.y += gravity * delta
	position += velocity * delta

	if ray_cast_2d.is_colliding() and not blinking:
		var collider = ray_cast_2d.get_collider()
		if collider is Centro:
			velocity.y = 0
			started = false
			blinking = true
			await get_tree().create_timer(1).timeout
			var base_color := Color(modulate.r, modulate.g, modulate.b, modulate.a)
			var t := create_tween()
			t.tween_property(self, "modulate", Color(base_color.r, base_color.g, base_color.b, 0.0), 0.2)
			t.tween_property(self, "modulate", Color(base_color.r, base_color.g, base_color.b, 1.0), 0.2)
			t.tween_property(self, "modulate", Color(base_color.r, base_color.g, base_color.b, 0.0), 0.2)
			t.tween_property(self, "modulate", Color(base_color.r, base_color.g, base_color.b, 1.0), 0.2)
			t.tween_property(self, "modulate", Color(base_color.r, base_color.g, base_color.b, 0.0), 0.2)

			await get_tree().create_timer(0.7).timeout
			queue_free()

func _on_bloques_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		started = true
