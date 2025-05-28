extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.player_position != Vector2.ZERO:
		$Player.global_position = GameState.player_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
