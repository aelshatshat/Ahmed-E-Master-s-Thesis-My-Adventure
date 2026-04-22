extends "res://AttackPattern.gd"

@export var damage: int = 10

func execute(boss: Node2D, player: Node2D):
	if boss.has_node("AnimatedSprite2D"):
		boss.get_node("AnimatedSprite2D").play("swipe")
	print("Boss uses swipe attack!")
	if player.global_position.distance_to(boss.global_position) < 80:
		if player.has_method("take_damage"):
			player.take_damage(damage)
