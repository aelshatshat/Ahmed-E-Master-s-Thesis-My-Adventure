class_name MeteorSwarm
extends "res://bosses/celestial_primate/Shared/AttackPattern.gd"

@export var meteor_scene: PackedScene
@export var count := 4
@export var spread_radius := 5.0

func execute(boss: Node2D, player: Node2D):
	if not meteor_scene:
		push_error("❌ Missing meteor_scene in MeteorSwarm")
		return

	var origin : Vector2 = boss.get_node("right_palm_origin").global_position
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in count:
		var meteor = meteor_scene.instantiate()

		# Predictive offset target near player
		var offset = rng.randf_range(-spread_radius, spread_radius)
		var target = player.global_position
		meteor.global_position = origin + Vector2(offset, 0)

		if meteor.has_method("set_target"):
			meteor.set_target(target, player)

		boss.get_parent().add_child(meteor)

	#print("🌠 MeteorSwarm fired from hand to player with spread.")
