extends Control


@onready var audio_confirm: AudioStreamPlayer = $Audio_confirm
@onready var audio_hover: AudioStreamPlayer = $Audio_hover


func _on_return_pressed() -> void:
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://Scenes/menu_inicial.tscn")
	

func _on_return_mouse_entered() -> void:
	audio_hover.play()
