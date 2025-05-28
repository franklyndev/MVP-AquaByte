extends CharacterBody2D
@export var boss_instance : PackedScene = preload("res://boss (2)/scene/turtlecrazy.tscn")
const BOMB = preload("res://boss (2)/scene/bomb.tscn")
const PROJETIL = preload("res://boss (2)/scene/projetil.tscn")
const SPEED = 8000.0
var direction = -1

@onready var detector: RayCast2D = $detector
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var projetil_point: Marker2D = %projetil_point
@onready var anime: AnimationPlayer = $anime
@onready var bomb_point: Marker2D = %bomb_point

@onready var animetree: AnimationTree = $animetree
@onready var state_machine = animetree["parameters/playback"]

var turn_cont := 0 
var projetil_cont := 0
var bomb_cont := 0
var can_launch_bomb = true
var can_launch_projetil := true
var player_hit := false
var boss_hp := 7
var is_dead: bool = false
#@export var boss_instance : PackedScene

func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	
	if detector.is_colliding():
		direction *= -1
		detector.scale.x *= -1
		turn_cont += 1 
	


	match state_machine.get_current_node():
		"move ":
			$hurtbox/colision.set_deferred("disabled", true)
			if direction == 1:
				velocity.x = SPEED * delta
				sprite_2d.flip_h = true
			else:
				velocity.x = -SPEED * delta
				sprite_2d.flip_h = false
		"projetil_attack":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			if can_launch_projetil:
				lancar_projetil()
				can_launch_projetil = false
		"bomb_attack":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			if can_launch_bomb:
				lancar_bomb()
				can_launch_bomb = false
		"vulneravel":
			can_launch_projetil = false
			can_launch_bomb = false
			await get_tree().create_timer(2).timeout
			player_hit = false
			$hurtbox/colision.set_deferred("disabled", false)

	if turn_cont <= 1:
		animetree.set("parameters/conditions/can_move", true)
		animetree.set("parameters/conditions/time_projetil", false)
	elif projetil_cont >= 2:
		animetree.set("parameters/conditions/time_bomb", true)
		projetil_cont = 0
	elif bomb_cont >= 3:
		animetree.set("parameters/conditions/is_vunerable", true)
		bomb_cont = 0
	else: 
		animetree.set("parameters/conditions/can_move", false)
		animetree.set("parameters/conditions/time_bomb", false)
		animetree.set("parameters/conditions/is_vulneravel", false)
		animetree.set("parameters/conditions/time_projetil", true)

	if boss_hp <= 0:
		state_machine.travel("death")
		await get_tree().create_timer(4.0).timeout
		queue_free()

	move_and_slide()

func lancar_bomb():
	if bomb_cont <=3:
		var bomb_intance = BOMB.instantiate()
		add_sibling(bomb_intance)
		bomb_intance.global_position = bomb_point.global_position
		bomb_intance.apply_impulse(Vector2(randi_range(direction * 75, direction * 200), randi_range(-200, -400)))
		$bomb_cooldown.start()
		bomb_cont += 1

func lancar_projetil():
	if projetil_cont <= 2:
		var projetil_instance = PROJETIL.instantiate()
		add_sibling(projetil_instance)
		projetil_instance.global_position = projetil_point.global_position
		projetil_instance.set_direction(direction)
		$projetil_cooldown.start()
		projetil_cont += 1

func _on_bomb_cooldown_timeout() -> void:
	can_launch_bomb = true
	
func _on_projetil_cooldown_timeout():
	can_launch_projetil = true

func _on_player_detector_body_entered(body: Node2D) -> void:
	set_physics_process(true)

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	set_physics_process(true)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	pass

func create_lose_boss():
	var boss_scene = boss_instance.instantiate()
	add_sibling(boss_scene)
	boss_scene.global_position = position
	
func take_damage(amount: int) -> void:
	if is_dead:
		return
	boss_hp -= amount
	if boss_hp <= 0:
		die()
func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	anime.play("death")
	await anime.animation_finished
	get_tree().change_scene_to_file("res://Scenes/telafimjogo.tscn")
		
		
		
	
