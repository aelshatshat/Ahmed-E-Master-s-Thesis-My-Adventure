extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

@export var lifetime := 1.0
@export var final_scale := 100.0

func _ready():
	sprite.scale = Vector2(0.2, 0.2)
	sprite.modulate = Color(1, 1, 1, 1)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(final_scale, final_scale), lifetime).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.finished.connect(queue_free)
