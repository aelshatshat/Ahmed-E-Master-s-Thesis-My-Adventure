extends Node

@export var max_health: float = 100.0
var current_health: float = max_health

signal health_changed(current: float, max: float)
signal player_died()

func take_damage(amount: float):
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0:
		emit_signal("player_died")

func heal(amount: float):
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health, max_health)

func is_alive() -> bool:
	return current_health > 0
