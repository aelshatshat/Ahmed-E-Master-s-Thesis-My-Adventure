extends Area2D
class_name MagicMissile

@export var speed: float = 400.0
@export var turn_rate: float = 4.0
@export var damage: int = 3

var target: Node2D = null

func _ready() -> void:
	# Find boss in enemy group
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		target = enemies[0]

func _physics_process(delta: float) -> void:
	if not target:
		queue_free()
		return
	
	var to_target = (target.global_position - global_position).normalized()
	var velocity = to_target * speed
	global_position += velocity * delta

	rotation = velocity.angle()

#func _on_body_entered(body: Node2D):
	#if body.is_in_group("enemy"):
		#if body.has_method("take_damage"):
			#body.take_damage(damage)
		#queue_free()


func _on_area_entered(area: Area2D) -> void:
	var parentBody = area.get_parent()
	if parentBody.is_in_group("enemy"):
		if parentBody.has_method("take_damage"):
			parentBody.take_damage(damage)
		queue_free()
