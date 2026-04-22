extends Node2D

var chaos_crush_attack = preload("res://bosses/celestial_primate/Attacks/ChaosCrush.gd").new()
var chaos_zone_scene = preload("res://bosses/celestial_primate/Attacks/ChaosZone.tscn")

func _ready():
	chaos_crush_attack.chaos_zone_scene = chaos_zone_scene

	# Simulate boss/player context
	var boss := self
	var player := get_parent().get_node("Player")
	
	await get_tree().create_timer(1.0).timeout  # Delay to observe
	chaos_crush_attack.execute(self, player)
