extends "res://bosses/celestial_primate/Shared/Movement/MovementPattern.gd"
class_name GlideMovement

@export var glide_time: float = 1.0
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition: Tween.TransitionType = Tween.TRANS_SINE

func execute(boss: Node2D, player: Node2D, from_anchor: BossAnchor, to_anchor: BossAnchor) -> void:
	var tween := boss.create_tween()
	tween.tween_property(boss, "global_position", to_anchor.global_position, glide_time)
	await tween.finished
