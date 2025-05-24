extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


var is_attacking: bool = false
var is_jumping := false
var is_dead = false
var is_paused: bool = false


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
		


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass
