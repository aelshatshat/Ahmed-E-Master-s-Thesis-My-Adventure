extends Node2D

var fire_column_attack = preload("res://bosses/celestial_primate/Attacks/FireColumnAttack.gd").new()
var fire_column_scene = preload("res://bosses/celestial_primate/Attacks/FireColumnEffect.tscn")

func _ready():
	fire_column_attack.fire_column_scene = fire_column_scene

	# Simulate boss/player context
	var boss := self
	var player := get_parent().get_node("Player")
	
	await get_tree().create_timer(1.0).timeout  # Delay to observe
	fire_column_attack.execute(self, player)
