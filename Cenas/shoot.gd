extends Area2D

var vel: float = 800.0

func _physics_process(delta: float) -> void:
	position += transform.x * vel * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		return
	if body.is_in_group("Enemy"):
		body.take_damage(1)

	queue_free()
