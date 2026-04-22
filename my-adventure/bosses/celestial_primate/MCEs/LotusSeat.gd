extends Node2D
class_name LotusSeat

@onready var sprite: AnimatedSprite2D = $LotusSeat

func _ready():
	sprite.play("idle")  # assumes you have an "idle" or pulsing anim
	modulate.a = 0.0
	await _fade_in()
	sprite.play("open")

func _fade_in():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func fade_out():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
