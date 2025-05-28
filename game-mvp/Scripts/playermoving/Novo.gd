extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const vida_max = 5
const dano = 1


@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var vida_label: Label = $vida_label
@onready var audio_faca: AudioStreamPlayer = $Faca
@onready var hurtsound: AudioStreamPlayer = $Hurtsound
@onready var deathsound: AudioStreamPlayer = $deathsound


var vida: int = vida_max
var is_attacking: bool = false
var is_jumping := false
var is_dead = false
var is_paused: bool = false
var invulneravel: bool = false

func _ready() -> void:
	atualizar_barra_vida()
	


func _physics_process(delta: float) -> void:
	
	if is_dead:
		return
	
	#pausar jogador
	if is_paused:
		velocity = Vector2.ZERO
		anim.play("idle")
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		is_jumping = true
	elif  is_on_floor():
		is_jumping = false
	
	# Ataque		
	if Input.is_action_just_pressed("Ataque") and not is_attacking:
		is_attacking = true
		anim.play("Attack")
		audio_faca.play()
		velocity.x = 0
		
	# Se estiver atacando, não mudar animação
	if is_attacking:
		move_and_slide()
		return

	# Movimento lateral e animações
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		sprite.scale = Vector2(sign(direction) * abs(sprite.scale.x), sprite.scale.y)
		if !is_jumping:
			anim.play("Running")
	elif  is_jumping:
		anim.play("Jumping")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")
		

	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		is_attacking = false
	elif anim_name == "hurt":  # ou "hurt", dependendo da animação
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
func _on_spike_body_entered(body: Node2D) -> void:
	if body == self and not is_dead:
		die()
		
func atualizar_barra_vida():
	if vida_label:
		vida_label.text = "%d/%d" % [vida, vida_max]
		
func take_damage(amount:int):
	if is_dead or invulneravel:
		return
	vida -= amount
	atualizar_barra_vida()
	if not hurtsound.playing:
		hurtsound.play()
	if vida <= 0:
		die()
		
func die():
	vida = 0
	is_dead = true
	atualizar_barra_vida()
	velocity = Vector2.ZERO
	anim.play("hurt")
	deathsound.play()

func _on_hitbox_body_entered(body: Node2D) -> void:	
	if body.is_in_group("enemy") and is_attacking:
		if body.has_method("take_damage"):
			body.take_damage(dano)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		take_damage(dano)
		
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/caverna.tscn")
		
