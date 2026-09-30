extends Node2D

@export var enemy_scene: PackedScene
@export var lantern_scene: PackedScene

@onready var enemy_spawn_points = $EnemySpawnPoints.get_children()
@onready var lantern_spawn_points = $LanternSpawnPoints.get_children()

func _on_timer_enemies_timeout() -> void:
	if enemy_spawn_points.size() > 0 and enemy_scene != null:
		var new_enemy = enemy_scene.instantiate()
		var sorted_point = enemy_spawn_points.pick_random()
		
		new_enemy.global_position = sorted_point.global_position
		add_child(new_enemy)

func _on_timer_lanterns_timeout() -> void:
	if lantern_spawn_points.size() > 0 and lantern_scene != null:
		var new_lantern = lantern_scene.instantiate()
		var sorted_point = lantern_spawn_points.pick_random()
		
		new_lantern.global_position = sorted_point.global_position
		add_child(new_lantern)
