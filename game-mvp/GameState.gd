extends Node

var player_position: Vector2 = Vector2.ZERO
var dialog_yago_concluido: bool = false

func save_position(pos: Vector2):
	player_position = pos

func reset_position():
	player_position = Vector2.ZERO
