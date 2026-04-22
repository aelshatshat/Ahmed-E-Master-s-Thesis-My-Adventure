extends "res://bosses/celestial_primate/Shared/Movement/MovementPattern.gd"
class_name ArcGlideMovement

##ArcGlideMovement (Rainbow Arc) → arc_height = 200, arc_lean = 0
##ArcGlideMovement (Right Swoop) → arc_height = 150, arc_lean = +0.8
##ArcGlideMovement (Left Swoop) → arc_height = 150, arc_lean = -0.8

@export var arc_height: float = 200.0   # how high the arc goes
@export var arc_lean: float = 0.0       # horizontal bias (-1 = left, +1 = right)
@export var ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_SINE

func execute(boss: Node2D, player: Node2D, from_anchor: Node2D, to_anchor: Node2D) -> void:
	if not boss or not from_anchor or not to_anchor:
		return

	var start := from_anchor.global_position
	var end := to_anchor.global_position

	# Midpoint: average, raised up, with optional horizontal lean
	var mid := (start + end) * 0.5
	var perp := Vector2(-(end.y - start.y), end.x - start.x).normalized()
	var control := mid + Vector2(0, -arc_height) + perp * (arc_height * arc_lean)

	var tween := boss.create_tween()
	tween.set_trans(trans)
	tween.set_ease(ease)

	# Animate using quadratic Bézier interpolation
	tween.tween_method(
		func(t: float):
			boss.global_position = _quadratic_bezier(start, control, end, t),
		0.0, 1.0, duration
	)

	await tween.finished

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	return (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2
