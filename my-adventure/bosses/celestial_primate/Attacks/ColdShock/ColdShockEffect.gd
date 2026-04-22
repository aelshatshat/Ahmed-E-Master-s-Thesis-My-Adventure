extends Area2D
class_name ColdShockEffect

@export var radius: float = 120.0
@export var delay_before_freeze: float = 1.5
@export var damage: int = 35
@export var slow_duration: float = 1.5

var has_triggered := false

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Set size of the AoE telegraph
	#if shape.shape is CapsuleShape2D:
	#shape.shape.radius = radius
	#shape.shape.height = radius

	# Telegraph animation
	sprite.play("telegraph")
	shape.disabled = true

	await get_tree().create_timer(delay_before_freeze).timeout
	erupt()

func erupt():
	if has_triggered:
		return
	has_triggered = true

	sprite.play("explode")
	shape.disabled = false

	# Let eruption linger briefly for hit detection
	await get_tree().create_timer(0.2).timeout
	shape.disabled = true

	## Allow eruption animation to finish before cleanup
	#await sprite.animation_finished
	# After eruption, fade out over 0.5s
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)

	# When fade is complete, clean up
	await tween.finished
	queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		# Damage
		if body.has_method("take_damage"):
			body.take_damage(damage)
		# Apply slow
		var mgr := body.get_node_or_null("StatusEffects")
		if mgr and mgr is StatusEffectManager:
			var slow := SlowEffect.new()
			slow.effect_type = &"slow"
			slow.duration = slow_duration
			slow.multiplier = 0.5  # 50% speed; tweak per attack/phase
			slow.stacking_mode = StatusEffect.STACK_REFRESH
			mgr.apply_effect(slow)
