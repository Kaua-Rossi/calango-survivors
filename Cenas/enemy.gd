extends CharacterBody2D

@export var cuscuz_scene: PackedScene
@export var vel: float = 65.0
var hp: int = 3
var player = null
var animation_time: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D 
@onready var eyes: Sprite2D = $Sprite2D/Eyes

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player != null:
		var dir = global_position.direction_to(player.global_position)
		velocity = dir * vel
		move_and_slide()
		global_rotation = dir.angle()
		animation_time += delta * 20.0 
		sprite.rotation = sin(animation_time) * 0.3
		
		var distance = global_position.distance_to(player.global_position)
		
		if (distance < 80):
			eyes.visible = true
		else:
			eyes.visible = false
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var object_collided = collision.get_collider()
			
			if object_collided.is_in_group("Player"):
				if object_collided.has_method("take_damage"):
					object_collided.take_damage(1)

func take_damage(dmg: int) -> void:
	hp -= dmg
	if hp <= 0:
		if randf() <= 0.30 and cuscuz_scene != null:
			var new_cuscuz = cuscuz_scene.instantiate()
			new_cuscuz.global_position = global_position
			
			get_tree().current_scene.call_deferred("add_child", new_cuscuz)
			
		queue_free()
