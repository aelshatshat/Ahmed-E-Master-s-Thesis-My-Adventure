extends "res://bosses/celestial_primate/Shared/Movement/MovementPattern.gd"
class_name TeleportMovement

@export var pause_time: float = 0.3  # Time hidden between start and end

func execute(boss: Node2D, player: Node2D, from_anchor: BossAnchor, to_anchor: BossAnchor) -> void:
	if not boss or not boss.has_node("AnimatedSprite2D"):
		return
	
	var anim: AnimatedSprite2D = boss.get_node("AnimatedSprite2D")

	# Step 1: Play teleport start animation
	anim.play("teleport_in")
	await anim.animation_finished
	
	# Step 2: Hide boss during teleport pause
	#boss.visible = false
	var tween := boss.create_tween()
	tween.tween_property(boss, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await boss.get_tree().create_timer(pause_time).timeout

	# Step 3: Move instantly to new anchor
	boss.global_position = to_anchor.global_position

	# Step 4: Show boss again + play teleport end animation
	#boss.visible = true
	var tween2 := boss.create_tween()
	tween2.tween_property(boss, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	anim.play("teleport_out")
	await anim.animation_finished
	await boss.get_tree().create_timer(pause_time).timeout
