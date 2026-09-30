extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("earn_light"):
			body.earn_light(0.5)
			queue_free()
