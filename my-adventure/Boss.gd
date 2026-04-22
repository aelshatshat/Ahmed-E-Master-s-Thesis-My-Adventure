extends "res://Enemy.gd"
class_name Boss

@export var phase_thresholds: Array[float] = [0.75, 0.5, 0.25] # health %
@onready var health_manager: Node = $HealthManager
var current_phase: int = 0
var boss_healthbar: BossHealthBar

signal phase_changed(new_phase: int)

func _ready() -> void:
	current_health = max_health
	health_manager.max_health = max_health
	health_manager.current_health = max_health
	add_to_group("enemy")
	
	# Find and setup boss healthbar
	boss_healthbar = get_tree().get_first_node_in_group("boss_healthbar")
	if boss_healthbar:
		boss_healthbar.setup_boss("Celestial Primate", health_manager.max_health)
		health_manager.connect("health_changed", Callable(self, "_on_health_changed"))
		health_manager.connect("die", Callable(self, "_on_boss_died"))

func _on_health_changed(current: int, max: int):
	if boss_healthbar:
		boss_healthbar.update_health(current, max)

func _on_boss_died():
	if boss_healthbar:
		boss_healthbar.hide_bar()

func take_damage(amount: int) -> void:
	super(amount) # call Enemy.take_damage
	health_manager.take_damage(amount)
	_check_phase_change()

func _check_phase_change() -> void:
	var health_pct: float = float(current_health) / float(max_health)
	for i in range(phase_thresholds.size()):
		if health_pct <= phase_thresholds[i] and current_phase == i:
			current_phase += 1
			phase_changed.emit(current_phase)
			break
