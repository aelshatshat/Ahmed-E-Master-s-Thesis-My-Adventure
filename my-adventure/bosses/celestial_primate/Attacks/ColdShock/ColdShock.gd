class_name ColdShock
extends "res://bosses/celestial_primate/Shared/AttackPattern.gd"

@export var cold_shock_scene: PackedScene
@export var radius := 120.0
@export var delay_before_freeze := 1.5
@export var damage := 35
@export var slow_duration := 1.5  # optional slow/freeze mechanic

func execute(boss: Node2D, player: Node2D):
	if not cold_shock_scene:
		push_error("❌ Missing cold_shock_scene in ColdShock")
		return

	# Spawn the zone at the player’s current location
	var shock = cold_shock_scene.instantiate()
	shock.global_position = player.global_position
	shock.radius = radius
	shock.delay_before_freeze = delay_before_freeze
	shock.damage = damage
	shock.slow_duration = slow_duration

	boss.get_parent().add_child(shock)

	#print("❄️ Cold Shock telegraph placed at player position.")
