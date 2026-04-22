extends Node2D
class_name YinYang

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var lifetime: float = 2.0

var active_tween: Tween = null
var effect_cancelled: bool = false

func _ready():
	# Start transparent and small
	modulate.a = 0.0
	scale = Vector2.ONE * 0.5
	sprite.play("default")

	_run_effect()

func _run_effect() -> void:
	active_tween = create_tween()

	# Fade in + slight grow
	active_tween.tween_property(self, "modulate:a", 1.0, 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	active_tween.parallel().tween_property(self, "scale", Vector2.ONE, 4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Glow flash effect mid-way
	active_tween.tween_callback(_try_flash_glow)

	# Hold briefly
	active_tween.tween_interval(lifetime * 0.3)

	# Grow larger and fade out
	active_tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	active_tween.parallel().tween_property(self, "modulate:a", 0.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	active_tween.tween_callback(queue_free)

func _try_flash_glow() -> void:
	if effect_cancelled:
		return
	_flash_glow()

func _flash_glow() -> void:
	var flash := create_tween()
	flash.tween_property(self, "scale", scale * 1.1, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flash.tween_property(self, "scale", scale, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func fade_out() -> void:
	effect_cancelled = true

	# Stop the original tween if it's still running
	if active_tween and active_tween.is_running():
		active_tween.kill()

	# Play break animation, then fade away manually
	sprite.play("break")
	#await sprite.animation_finished

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)
