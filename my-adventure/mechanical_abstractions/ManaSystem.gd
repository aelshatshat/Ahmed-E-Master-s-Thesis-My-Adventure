extends Node

@export var max_mana: float = 100.0
@export var regen_rate: float = 1.0        # mana/sec
@export var mana_per_hit: float = 3.0      # restored on melee hit

var current_mana: float = max_mana
signal mana_changed(current: float, max: float)

func _process(delta: float) -> void:
	if current_mana < max_mana:
		current_mana = min(max_mana, current_mana + regen_rate * delta)
		emit_signal("mana_changed", current_mana, max_mana)

func can_cast(cost: float) -> bool:
	return current_mana >= cost

func spend_mana(cost: float) -> void:
	current_mana = max(0, current_mana - cost)
	emit_signal("mana_changed", current_mana, max_mana)

func restore_mana_on_hit() -> void:
	current_mana = min(max_mana, current_mana + mana_per_hit)
	emit_signal("mana_changed", current_mana, max_mana)
