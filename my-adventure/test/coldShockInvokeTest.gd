extends Node2D

var cold_shock_attack = preload("res://bosses/celestial_primate/Attacks/ColdShock.gd").new()
var cold_shock_scene = preload("res://bosses/celestial_primate/Attacks/ColdShockEffect.tscn")

func _ready():
	cold_shock_attack.cold_shock_scene = cold_shock_scene

	# Simulate boss/player context
	var boss := self
	var player := get_parent().get_node("Player")
	
	await get_tree().create_timer(1.0).timeout  # Delay to observe
	cold_shock_attack.execute(self, player)
