extends Node2D

@export var max_hp: int = 100          # Vida máxima
@export var current_hp: int = 100      # Vida atual
@export var attack_power: int = 10     # Poder de ataque


var min_attack_power: int = 8
var max_attack_power: int = 12

# Função para receber dano
func take_damage(amount: int) -> void:
	# Reduz a vida atual mas nunca deixa negativa
	current_hp = max(current_hp - amount, 0)
	print("%s recebeu %d de dano! Vida atual: %d" % [name, amount, current_hp])

# Função para checar se o personagem morreu
func is_dead() -> bool:
	return current_hp == 0


func get_attack_damage() -> int:
	return attack_power
