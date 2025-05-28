extends CanvasLayer

@onready var menu = $Control

enum TelaCarregada {NADA, SÓ_MENU}
var tela_carregada = TelaCarregada.NADA

func _ready():
	menu.visible = false 
	await get_tree().create_timer(3.5).timeout
	menu.visible = true 


#func _unhandled_input(event):
	match tela_carregada:
		TelaCarregada.NADA:
			#if event.is_action_pressed('menu'):
				menu.visible = true
				tela_carregada = TelaCarregada.SÓ_MENU 
		
