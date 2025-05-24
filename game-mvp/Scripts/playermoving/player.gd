extends CharacterBody2D

@export var speed: float = 200.0
@export var gravity: float = 1000.0
@export var jump_force: float = 400.0

func _physics_process(delta: float) -> void:
	var direction = 0.0

	# Movimento lateral
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1

	velocity.x = direction * speed

	# Aplicando gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Pulo só se estiver no chão
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_force

	move_and_slide()
