extends Node
class_name StatusEffectManager

signal effect_applied(effect: StatusEffect)
signal effect_removed(effect_type: StringName)
signal modifiers_changed()
signal tint_changed(color: Color, opacity: float)  # 👈 NEW

var active_effects: Dictionary = {} # effect_type -> ActiveEntry

# ActiveEntry layout:
# {
# 	"effect": StatusEffect,
# 	"remaining": float,
# 	"stacks": int,
# 	"tick_acc": float, # for periodic effects
# }

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var to_remove: Array[StringName] = []
	for effect_type in active_effects.keys():
		var entry = active_effects[effect_type]
		entry["remaining"] -= delta

		# Process periodic ticks
		_process_periodic(entry, delta)

		if entry["remaining"] <= 0.0:
			to_remove.append(effect_type)

	for et in to_remove:
		_remove_effect(et)

func apply_effect(effect: StatusEffect) -> void:
	if effect == null:
		return

	var et: StringName = effect.effect_type
	if et == &"":
		push_warning("StatusEffect missing effect_type")
		return

	var changed := false

	if active_effects.has(et):
		var entry = active_effects[et]
		match effect.stacking_mode:
			StatusEffect.STACK_REFRESH:
				entry["remaining"] = max(entry["remaining"], effect.duration)
				entry["effect"] = effect
				changed = true
			StatusEffect.STACK_STACK:
				if entry["stacks"] < effect.max_stacks:
					entry["stacks"] += 1
					entry["remaining"] = max(entry["remaining"], effect.duration)
					entry["effect"] = effect
					changed = true
			StatusEffect.STACK_IGNORE:
				pass
	else:
		active_effects[et] = {
			"effect": effect,
			"remaining": effect.duration,
			"stacks": 1,
			"tick_acc": 0.0
		}
		changed = true

	if changed:
		emit_signal("effect_applied", effect)
		emit_signal("modifiers_changed")
		_update_tint()  # 👈 update colors

func _remove_effect(effect_type: StringName) -> void:
	if not active_effects.has(effect_type):
		return
	active_effects.erase(effect_type)
	emit_signal("effect_removed", effect_type)
	emit_signal("modifiers_changed")
	_update_tint()  # 👈 update colors

func clear_all() -> void:
	if active_effects.is_empty():
		return
	active_effects.clear()
	emit_signal("modifiers_changed")
	_update_tint()  # 👈 update colors

# ---- Query API ----

func get_move_speed_multiplier() -> float:
	var mult := 1.0
	for entry in active_effects.values():
		var e: StatusEffect = entry["effect"]
		if e is SlowEffect:
			var stacks: int = entry["stacks"]
			for i in stacks:
				mult *= max(0.0, (e as SlowEffect).multiplier)
	return clamp(mult, 0.0, 1.0)

func is_stunned() -> bool:
	return active_effects.has(&"stun")

func is_invulnerable() -> bool:
	return active_effects.has(&"invulnerable")

# ---- Periodic effects ----

func _process_periodic(entry: Dictionary, delta: float) -> void:
	var e: StatusEffect = entry["effect"]
	if e is PoisonEffect:
		entry["tick_acc"] += delta
		var pe := e as PoisonEffect
		while entry["tick_acc"] >= pe.tick_interval:
			entry["tick_acc"] -= pe.tick_interval
			var owner := get_parent()
			if owner and owner.has_method("take_damage"):
				owner.take_damage(pe.tick_damage)

# ---- NEW: Tint logic ----

func _update_tint() -> void:
	var color := Color(1, 1, 1)
	var opacity := 1.0

	for entry in active_effects.values():
		var e: StatusEffect = entry["effect"]
		match e.effect_type:
			&"invulnerable":
				opacity = 0.5
			&"slowed":
				color = color.blend(Color(0.5, 0.5, 1)) # bluish
			&"poison":
				color = color.blend(Color(0.6, 0.1, 0.6)) # purple tint
			_:
				pass

	emit_signal("tint_changed", color, opacity)
