extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -300.0

@onready var anim: AnimatedSprite2D = $Protagonista

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
					

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		anim.scale = Vector2(sign(direction), 1)
		if !is_jumping:
			anim.play("Running")
	elif  is_jumping:
		anim.play("Jumping")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")

	move_and_slide()
