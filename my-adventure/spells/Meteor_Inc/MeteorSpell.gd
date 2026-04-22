extends Node2D

func _ready():
	# Example: play animation, deal damage in area
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("impact")
	await $AnimatedSprite2D.animation_finished
	queue_free()
