extends Node2D

@onready var label: Label = $Label
@onready var player: Node = null
@onready var timer: Timer = $Timer


var player_in_area: bool = false
var dialog_index: int = -1
var dialog_list: Array[String] = [
	"FERREIRO",
	"Tá vendo essa lâmina, garoto?", 
	"Não é só ferro e fogo… é responsabilidade.",
	"Ela vai cortar o que for preciso…",
	"mas lembra: a espada não é quem guia…",
	"quem guia é você…",
	"E dizem… que Nymara…" ,
	"o Espírito das Águas…",
	"vai te acompanhar nessa jornada.",
	"Não desperdice isso." ,
	"Espírito assim…" ,
	"só aparece pra quem tem alma pura.",
	"Vai… e honra essa espada…",
	"e a confiança que ela carrega",
]

var dialog_shown: bool = false  # impede repetir

func _ready():
	label.visible = false
	
func _process(delta):
	# Verifica se o jogador está na área e pressionou E para interagir
	if player_in_area and Input.is_action_just_pressed("Interact") and not dialog_shown:
		dialog_index += 1
		_pause_player(true) #pausa o movimento do jogador
	
		if dialog_index < dialog_list.size():
			label.text = dialog_list[dialog_index]
		else:
			label.visible = false
			dialog_index = -1
			dialog_shown = true  # Após o último diálogo, marca como mostrado
			_pause_player(false)  # Retorna o jogador ao normal
			
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_area = true
		dialog_index = -1
		label.visible = true
		
		if not dialog_shown:
			label.text = "Pressione 'E' para interagir"
			#_pause_player(true)  # Pausa o jogador ao entrar na area
		else:
			label.text = ""
			timer.start() 
			

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not dialog_shown:
		player_in_area = false
		label.visible = false
		dialog_index = -1
		player = null
		
		#_pause_game(false)  # Despausa quando o jogador sai da área
	
		

# Função para pausar ou despausar o movimento do jogador
func _pause_player(pause: bool) -> void:
	if player and "is_paused" in player:
		player.is_paused = pause
		
	#get_tree().paused = pause


func _on_timer_timeout() -> void:
	label.visible = false
