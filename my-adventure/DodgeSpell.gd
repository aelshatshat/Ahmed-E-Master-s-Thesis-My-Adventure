extends Resource
class_name DodgeSpell

@export var cooldown_time: float = 1.0
@export var invulnerability_time: float = 1
@export var dodge_time: float = 0.5
@export var dodge_velocity: Vector2 = Vector2(1000, 0)

func perform_dodge(caster: Node, player: Node2D):
	if not player.has_method("enter_dodge") or not player.has_method("exit_dodge"):
		push_error("Player must implement enter_dodge and exit_dodge")
		return

	player.enter_dodge(invulnerability_time, dodge_time)
	player.apply_dodge_impulse(dodge_velocity)
	caster._start_dodge_cooldown()
