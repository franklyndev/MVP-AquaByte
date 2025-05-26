extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector: RayCast2D = $Wall_detector
@onready var texture: Sprite2D = $texture
@onready var anim: AnimationPlayer = $AnimEnemy



var direction := 1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Sistema de vida
@export var max_health: int = 2
var current_health: int = max_health
var is_dead: bool = false



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y +=  gravity * delta
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		
	if direction == 1:
		texture.flip_h = false
	else:
		texture.flip_h = true
		
	if direction:
		velocity.x = direction * SPEED * delta
	
	move_and_slide()
	
	# Método para receber dano
func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_health -= amount
	if current_health <= 0:
		die()
func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("hurt2") 
	
func _on_anim_enemy_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt2":
		queue_free()
		
