extends RigidBody2D

const EXPLOSION = preload("res://scene/explosion.tscn")
@onready var colision: CollisionShape2D = $colision

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.take_damage()
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	colision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
