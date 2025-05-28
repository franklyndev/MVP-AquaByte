class_name CenaBatalha

extends Node2D

# Pega as referências para os personagens e para a interface
@onready var player = $Player
@onready var enemy = $eneym

@onready var attack_button = $TextureRect/Menu/Button
@onready var player_hp_bar = $Player/ProgressPlay
@onready var enemy_hp_bar = $eneym/ProgressEnemy
@onready var curar_button = $TextureRect/Menu/Button2
@onready var fugir_button =$TextureRect/Menu/Button3


# Variável para controlar de quem é a vez
var player_turn: bool = true
# Variável para controlar a quantidade de vida
var heal_uses_left: int = 2

#Emite sons do jogador e inimigo
@onready var punch_sound: AudioStreamPlayer2D = $Player/PunchSound
@onready var enemy_punch: AudioStreamPlayer2D = $eneym/EnemyPunch
@onready var heal_sound: AudioStreamPlayer2D = $Player/HealSound


@onready var v_box_container: VBoxContainer = $TextureRect/Menu/VBoxContainer


func _ready():
	# Estilo da barra de vida do jogador
	stylize_bar(player_hp_bar, Color(0.8, 0, 0), Color(0.15, 0, 0))
	stylize_label(player_hp_bar.get_node("Label"))

	# Estilo da barra de vida do inimigo
	stylize_bar(enemy_hp_bar, Color(0.5, 0, 0.5), Color(0.1, 0, 0.1))
	stylize_label(enemy_hp_bar.get_node("Label"))
	
	v_box_container.visible = false #Disabilita o menu no incio da cena
	update_ui()
	
	$Label/TextureRect2/Label.text = "QUE COMECE A BATALHA"
	await get_tree().create_timer(1.5).timeout
	$Label/TextureRect2/Label.text = "ATACANDO!"
	await get_tree().create_timer(2.0).timeout
	v_box_container.visible = true

# Função que executa o ataque do jogador
func player_attack():
	var damage = player.get_attack_damage()
	enemy.take_damage(damage)
	attack_button.disabled = true
	curar_button.disabled = true
	fugir_button.disabled = true
	await get_tree().create_timer(0.5).timeout
	$TextureRect/Menu.visible = false
	# Atualiza a interface após o ataque
	update_ui()
	
	# Verifica se o inimigo morreu
	if enemy.is_dead():
		attack_button.disabled = true  # Desativa o botão de ataque\
		await get_tree().create_timer(1.0).timeout
		$eneym/LabelEnemy.text = "VOCÊ GANHOU!"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Assets definitivos/Cuspidor/caverna.tscn")
		return
	
	player_turn = false
	$Label/TextureRect2/Label.text = "ATAQUE INIMIGO!"
	print($Label/TextureRect2/Label)
	
	# Espera um segundo antes do inimigo agir (efeito de "tempo de reação")
	await get_tree().create_timer(1.0).timeout
	# Chama a ação do inimigo
	enemy_action()
	await get_tree().create_timer(1.5).timeout
	$TextureRect/Menu.visible = true
	
# Função que executa o ataque do inimigo
func enemy_action():
	attack_button.disabled = false
	if enemy.current_hp > 25: 
		# Espera mais 1 segundo para dar suspense
		await get_tree().create_timer(1.0).timeout
		# Inimigo causa dano no jogador
		var damage = enemy.get_attack_damage()
		player.take_damage(damage)
		curar_button.disabled = false
		fugir_button.disabled = false
		enemy_punch.play()
	else:
		await get_tree().create_timer(1.0).timeout
		enemy.current_hp +=randi_range(5,14)
		curar_button.disabled = false
		heal_sound.play()
	# Atualiza a interface após o ataque
	update_ui()
	
	
	# Verifica se o jogador morreu
	if player.is_dead():
		attack_button.disabled = true
		await get_tree().create_timer(1.0).timeout
		$Player/LabelPlayer.text = "VOCÊ PERDEU"
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	# Se o jogador não morreu, volta a vez para o jogador
	player_turn = true
	$Label/TextureRect2/Label.text = "SEU TURNO"
	print($Label/TextureRect2/Label)

# Função para atualizar as barras de vida
func update_ui():
# Atualiza barra de vida do jogador
	player_hp_bar.max_value = player.max_hp
	player_hp_bar.value = player.current_hp
	player_hp_bar.get_node("Label").text = "Vida: %d / %d" % [player.current_hp, player.max_hp]
# Atualiza barra de vida do inimigo
	enemy_hp_bar.max_value = enemy.max_hp
	enemy_hp_bar.value = enemy.current_hp
	enemy_hp_bar.get_node("Label").text = "Inimigo: %d / %d" % [enemy.current_hp, enemy.max_hp]


func _on_button_pressed() -> void:
	if not player_turn:
		# Se não for o turno do jogador, ignora o clique
		return
	if enemy.is_dead():
		get_tree().quit()
	# Realiza o ataque do jogador
	player_attack()
	punch_sound.play()

func curar() -> void:
	player.current_hp +=randi_range(5,10)
	heal_uses_left -=1
	print("o %s curou %d de vida:" % [name, randi_range(5,10)])
	
	if player.current_hp >= player.max_hp:
		player.current_hp = player.max_hp
		print("a")
	if heal_uses_left <=0:
		curar_button.disabled = true
	curar_button.disabled = true
	
	

func _on_button_2_pressed() -> void:
	curar()
	enemy_action()
	update_ui()
	heal_sound.play()
	$TextureRect/Menu.visible = false
	player_turn = true
	
	attack_button.disabled = false
	await get_tree().create_timer(1.8).timeout
	$TextureRect/Menu.visible = true
	return
	


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("proxima cena")


func stylize_bar(bar: ProgressBar, fill_color: Color, bg_color: Color):
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = bg_color
	bar.add_theme_stylebox_override("bg", bg_style)

	var fg_style = StyleBoxFlat.new()
	fg_style.bg_color = fill_color
	bar.add_theme_stylebox_override("fg", fg_style)

func stylize_label(label: Label):
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
