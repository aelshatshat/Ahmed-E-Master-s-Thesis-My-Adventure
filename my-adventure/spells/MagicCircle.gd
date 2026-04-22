extends Node2D

var jump_pos: Vector2 = Vector2(0,0)
var jump_set = false
func play_jump_cast():
	# Ensure we start from transparent
	modulate = Color(1, 1, 1, 0)
	
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	$AnimatedSprite2D.global_position = jump_pos
	$AnimatedSprite2D.play("jump_cast")

	await $AnimatedSprite2D.animation_finished
	var tween2 := create_tween()
	tween2.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween2.finished
	queue_free()

func play_cast():
	# Ensure we start from transparent
	modulate = Color(1, 1, 1, 0)
	
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	$AnimatedSprite2D.play("channel")

func end_cast():
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()
	
func set_jump_pos(pos : Vector2):
	jump_pos = pos
	jump_set = true
