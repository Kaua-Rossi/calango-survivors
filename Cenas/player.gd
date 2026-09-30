extends CharacterBody2D

@export var shoot_scene: PackedScene
@export var vel: float = 50.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var shotgun: AnimatedSprite2D = $Shotgun
@onready var hud_label = $CanvasLayer/Label

var max_ammo: int = 5
var current_ammo: int = 5
var isReloading: bool = false
var isShooting: bool = false
var hp: int = 3
var invulnerable: bool = false
var isDead: bool = false
var time_remaining: float = 300.0 # 5 minutos
var isWin: bool = false
var max_light: float = 3.0
var current_light: float = 1.5
var light_rate: float = 0.05

func _physics_process(_delta: float) -> void:
	if not isWin:
		if time_remaining > 0:
			time_remaining -= _delta
		else:
			time_remaining = 0
			isWin = true
			win_the_game()
	
	var minutes : int = int(time_remaining) / 60
	var seconds : int = int(time_remaining) % 60
	
	hud_label.text = "Tempo: %02d:%02d | HP: %d | Munição: %d/%d" % [minutes, seconds, hp, current_ammo, max_ammo]
	var dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * vel
	move_and_slide()
	
	if dir != Vector2.ZERO:
		animation.play("Walking")		
		if dir.x != 0:
			animation.flip_h = dir.x < 0
	else:
		animation.play("Idle")
	
	var mouse_position = get_global_mouse_position()
	
	light.global_position = mouse_position
	shotgun.global_rotation = global_position.direction_to(mouse_position).angle()
	
	if current_light > 0.2:
		current_light -= light_rate * _delta
	
	light.texture_scale = current_light
	
	if mouse_position.x < shotgun.global_position.x:
		shotgun.flip_v = true
	else:
		shotgun.flip_v = false
	
	if Input.is_action_just_pressed("Shoot"):
		shoot()
	elif Input.is_action_just_pressed("Reload"):
		start_reload()

func shoot():
	if isShooting:
		return
	
	if current_ammo > 0:
		if isReloading:
			isReloading = false
		
		isShooting = true
		
		for i in range(6):
			var new_shoot = shoot_scene.instantiate()
			get_tree().root.add_child(new_shoot)
			new_shoot.global_transform = shotgun.global_transform
			new_shoot.global_rotation += randf_range(-deg_to_rad(15), deg_to_rad(15))
			new_shoot.vel = randf_range(600, 800)
		current_ammo -= 1
		shotgun.play("Shooting")
	else:
		pass

func start_reload():
	if current_ammo < max_ammo and not isReloading:
		isReloading = true
		shotgun.play("Reloading")

func _on_shotgun_animation_finished() -> void:
	if shotgun.animation == "Idle":
		if not isReloading:
			shotgun.play("Idle")
	
	elif shotgun.animation == "Reloading":
		if isReloading:
			current_ammo += 1
			
			if current_ammo < max_ammo:
				shotgun.play("Reloading")
				isShooting = false
			else:
				isShooting = false
				isReloading = false
				shotgun.play("Idle")
	
	elif shotgun.animation == "Shooting":
		isShooting = false
		shotgun.play("Idle")
	pass # Replace with function body.

func earn_light(quantity: float) -> void:
	current_light += quantity
	if current_light > max_light:
		current_light = max_light

func take_damage(dmg: int) -> void:
	if invulnerable or isDead:
		return
		
	hp -= dmg
	
	if hp <= 0:
		isDead = true
		get_tree().call_deferred("change_scene_to_file", "res://Cenas/death_menu.tscn")
	else:
		invulnerable = true
		
		for i in range(6):
			animation.visible = not animation.visible
			await get_tree().create_timer(0.1).timeout 
			
		animation.visible = true
		invulnerable = false

func heal(amount: int) -> void:
	hp += amount
	if hp > 3:
		hp = 3

func win_the_game() -> void:
	get_tree().change_scene_to_file("res://Cenas/win_menu.tscn")
