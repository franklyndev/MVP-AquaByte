extends AnimatableBody2D

const SPEED := 200.0
const EXPLOSION = preload("res://scene/explosion.tscn")
@onready var sprite: Sprite2D = $sprite
@onready var proj_colision: CollisionShape2D = $proj_colision
@onready var colision: CollisionShape2D = $detector/colision

var velocity := Vector2.ZERO
var direction = 0

func _process(delta):
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)

func set_direction(dir):
	direction = dir 
	if direction == 1:
		sprite.flip_h = true 
	else:
		sprite.flip_h = false
	

func _on_detector_body_entered(body):
	if body.name == "player":
		body.take_damage()
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	await explosion_instance.animation_finished
	queue_free()
