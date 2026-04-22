extends Node2D

func _ready() -> void:
	# Play impact animation and remove after it finishes
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("impact")
		await $AnimatedSprite2D.animation_finished
	queue_free()
