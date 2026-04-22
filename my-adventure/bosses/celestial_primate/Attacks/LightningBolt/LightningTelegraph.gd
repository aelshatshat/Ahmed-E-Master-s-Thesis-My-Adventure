extends Node2D
class_name LightningTelegraph

@export var duration: float = 0.8

@onready var sprite := $AnimatedSprite2D

func _ready():
	sprite.play("default")
	var tween := create_tween()
	tween.tween_property(sprite, "rotation_degrees", 180, 0.8)
	
func end():
	queue_free()
