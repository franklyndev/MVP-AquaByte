extends CanvasLayer


@onready var continuar_jogo: Button = $menu_holder/Continuar_Jogo
@onready var audio_pause: AudioStreamPlayer = $Audio_pause
@onready var audio_unpause: AudioStreamPlayer = $Audio_unpause
@onready var audio_confirm: AudioStreamPlayer = $Audio_confirm
@onready var audio_hover: AudioStreamPlayer = $Audio_hover


var cont = 0
func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			audio_unpause.play()
			get_tree().paused = false
			visible = false
		else:
			audio_pause.play()
			get_tree().paused = true
			visible = true
			continuar_jogo.grab_focus()


func _process(delta: float) -> void:
	pass


func _on_sair_do_jogo_pressed() -> void:
	audio_confirm.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()
	

func _on_continuar_jogo_pressed() -> void:
	audio_confirm.play()
	get_tree().paused = false
	visible = false


func _on_config_menu_pressed() -> void:
	audio_confirm.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu_inicial.tscn")
	

func _on_continuar_jogo_mouse_entered() -> void:
	audio_hover.play()


func _on_config_menu_mouse_entered() -> void:
	audio_hover.play()


func _on_sair_do_jogo_mouse_entered() -> void:
	audio_hover.play()
