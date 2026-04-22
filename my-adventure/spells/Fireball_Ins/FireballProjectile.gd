extends Area2D

@export var speed: float = 300.0
@export var damage: int = 10
@export var impact_effect: PackedScene  # Assign FireballImpact.tscn in Inspector

var direction: int = 1

func set_direction(dir: int) -> void:
	direction = dir
	# Flip sprite if needed
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = dir < 0
		$AnimatedSprite2D.play("default");

func _process(delta: float) -> void:
	global_position.x += speed * delta * direction
	
	# Optional: lifetime timer
	if global_position.x > 2000 or global_position.x < -2000:
		_spawn_impact_effect()
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		_spawn_impact_effect()
		queue_free()

func _spawn_impact_effect() -> void:
	if impact_effect:
		var effect = impact_effect.instantiate()
		effect.global_position = global_position
		get_parent().add_child(effect)


func _on_area_entered(area: Area2D) -> void:
	var parentBody = area.get_parent()
	if parentBody.is_in_group("enemy"):
		if parentBody.has_method("take_damage"):
			parentBody.take_damage(damage)
		queue_free()
