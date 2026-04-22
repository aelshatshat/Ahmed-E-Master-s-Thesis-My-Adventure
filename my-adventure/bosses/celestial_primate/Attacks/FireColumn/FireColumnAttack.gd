class_name FireColumnAttack
extends "res://bosses/celestial_primate/Shared/AttackPattern.gd"

@export var fire_column_scene: PackedScene
@export var count := 1                # number of columns
@export var spacing := 128.0          # horizontal distance between columns
@export var randomize_positions := false
@export var telegraph_time := 1.0     # seconds before erupting

func execute(boss: Node2D, player: Node2D):
	if not fire_column_scene:
		push_error("❌ Missing fire_column_scene in FireColumnAttack")
		return

	var floor_y = get_floor_position_below(boss).y - 155
	var player_x = player.global_position.x

	# Get visible screen bounds (in world coordinates)
	var viewport := boss.get_viewport_rect()
	var camera := boss.get_viewport().get_camera_2d()
	var screen_left = camera.global_position.x - viewport.size.x * 0.5
	var screen_right = camera.global_position.x + viewport.size.x * 0.5
	var screen_width = viewport.size.x

	# Compute player’s normalized position within screen [0,1]
	var rel_x : Variant = clamp((player_x - screen_left) / screen_width, 0.0, 1.0)

	# Determine pattern direction based on player position
	# - Left quarter: mostly spawn to the right
	# - Right quarter: mostly spawn to the left
	# - Middle: balanced spread
	var x_positions: Array[float] = []

	if count <= 1:
		x_positions.append(player_x)
	else:
		if rel_x < 0.25:
			# Player near left edge → all to the right
			for i in range(count):
				x_positions.append(player_x + i * spacing)
		elif rel_x > 0.75:
			# Player near right edge → all to the left
			for i in range(count):
				x_positions.append(player_x - i * spacing)
		else:
			# Player near middle → symmetrical pattern
			var half := count / 2.0
			for i in range(count):
				var offset = (i - floor(half)) * spacing
				x_positions.append(player_x + offset)

	# Randomization tweak (optional)
	if randomize_positions:
		x_positions.shuffle()

	# Spawn columns
	for x_pos in x_positions:
		var column = fire_column_scene.instantiate()
		column.global_position = Vector2(x_pos, floor_y)
		boss.get_parent().add_child(column)


func get_floor_position_below(node: Node2D, distance: float = 5000.0) -> Vector2:
	var raycast = RayCast2D.new()
	node.add_child(raycast)
	raycast.target_position = Vector2(0, distance)
	raycast.enabled = true
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var floor_pos = raycast.get_collision_point()
		raycast.queue_free()
		return floor_pos

	raycast.queue_free()
	return Vector2.ZERO  # Or handle no collision case
