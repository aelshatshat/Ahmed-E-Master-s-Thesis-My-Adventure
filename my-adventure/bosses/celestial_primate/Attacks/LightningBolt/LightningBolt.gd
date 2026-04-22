class_name LightningBolt
extends "res://bosses/celestial_primate/Shared/AttackPattern.gd"

@export var bolt_scene: PackedScene          # LightningBoltEffect.tscn
@export var telegraph_scene: PackedScene     # LightningTelegraph.tscn
@export var damage: int = 20
@export var telegraph_time: float = 0.8
@export var lifetime: float = 0.25
@export var segments: int = 16
@export var jitter: float =15.0
@export var fork_chance: float = 0.2
@export var fork_length: float = 0.4

func execute(boss: Node2D, player: Node2D) -> void:
	if not bolt_scene or not telegraph_scene:
		push_error("⚡ LightningBolt: missing bolt_scene or telegraph_scene")
		return
	
	var origin : Vector2 = boss.get_node("left_finger_origin").global_position
	
	if(player.global_position > boss.global_position):
		origin = boss.get_node("right_finger_origin").global_position
		if(boss.anim.animation == "left_point"):
			boss.swap_hands("right")
	else:
		if(boss.anim.animation == "right_point"):
			boss.swap_hands("left")
	var strike_pos := player.global_position  # lock-in location NOW

	# Place telegraph marker
	#var telegraph := telegraph_scene.instantiate()
	#telegraph.global_position = strike_pos + Vector2(0, 30)
	#boss.get_parent().add_child(telegraph)

	# Wait for telegraph, then strike
	var scene_tree := boss.get_tree()
	var bolt := bolt_scene.instantiate()
	boss.get_parent().add_child(bolt)

	bolt.call_deferred(
		"setup",
		origin,
		strike_pos,
		damage,
		lifetime,
		segments,
		jitter,
		fork_chance,
		fork_length
	)
	scene_tree.create_timer(telegraph_time).timeout.connect(func():
		#telegraph.end()
		bolt.trigger_lightning(lifetime)
	)
