class_name ChaosCrush
extends "res://bosses/celestial_primate/Shared/AttackPattern.gd"

@export var chaos_zone_scene: PackedScene
@export var zone_count: int = 1

func execute(boss: Node2D, player: Node2D) -> void:
	if not chaos_zone_scene:
		push_error("❌ Missing chaos_zone_scene for ChaosCrush")
		return

	var zones: Array = []

	for i in zone_count:
		var zone = chaos_zone_scene.instantiate()
		zone.global_position.y -= 60
		boss.get_parent().add_child(zone)
		zones.append(zone)

	# Wait for all zones to emit zone_finished
	for zone in zones:
		await zone.zone_finished

	#print("💥 Chaos Crush complete: all zones resolved")
