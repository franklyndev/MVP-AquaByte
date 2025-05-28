extends Control


@onready var audio_confirm: AudioStreamPlayer = $Audio_confirm
@onready var audio_hover: AudioStreamPlayer = $Audio_hover


func _on_inicar_pressed() -> void:
	
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://Scenes/World.tscn") #colocar o caminho da primeira fase do jogo


func _on_creditos_pressed() -> void:
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://Scenes/telafimjogo.tscn")  #Colocar caminho da cena dos creditos


func _on_sair_do_jogo_pressed() -> void:	
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().quit()
	

func _on_options_pressed() -> void:
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://Scenes/menu_config.tscn")




func _on_start_mouse_entered() -> void:
	audio_hover.play()


func _on_options_mouse_entered() -> void:
	audio_hover.play()


func _on_credit_mouse_entered() -> void:
	audio_hover.play()


func _on_quitgame_mouse_entered() -> void:
	audio_hover.play()
