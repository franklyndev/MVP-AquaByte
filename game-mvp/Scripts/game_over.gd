extends Control


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")
	


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_inicial.tscn")
