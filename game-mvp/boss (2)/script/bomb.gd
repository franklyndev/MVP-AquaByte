extends RigidBody2D

const EXPLOSION = preload("res://boss (2)/scene/explosion.tscn")
@onready var colision: CollisionShape2D = $colision

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	colision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
