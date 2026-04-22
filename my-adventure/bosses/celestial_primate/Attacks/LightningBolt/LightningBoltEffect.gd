extends Node2D
class_name LightningBoltEffect

@onready var line_main := Line2D.new()
var branch_lines: Array[Line2D] = []
var rng := RandomNumberGenerator.new()

var _damage: int
var _lifetime: float

func _ready():
	add_child(line_main)
	line_main.width = 3.5
	line_main.default_color = Color.BLACK
	line_main.modulate.a = 0

func setup(origin: Vector2, strike_pos: Vector2, damage: int, lifetime: float, segments: int, jitter: float, fork_chance: float, fork_length: float):
	global_position = origin
	_damage = damage
	_lifetime = lifetime
	rng.randomize()

	# Build jagged bolt until just before strike_pos
	var main_points := _make_jagged_points(Vector2.ZERO, strike_pos - origin, max(1, segments - 2), jitter)

	# Force second-last point = player location at telegraph
	main_points.append(strike_pos - origin + Vector2(0, 30))

	# Final point = ground nearby
	var floor_offset := Vector2(rng.randf_range(-30, 30), rng.randf_range(60, 60))
	main_points.append((strike_pos - origin) + floor_offset)

	line_main.points = main_points
	
	var tween := create_tween()
	tween.tween_property(line_main, "modulate:a", 0.5, 0.8)

	# Optional forks along the bolt
	#for i in range(1, main_points.size() - 2): # skip last 2 fixed points
		#if rng.randf() < fork_chance:
			#var fork_dir := (strike_pos - origin).normalized().rotated(rng.randf_range(-0.8, 0.8))
			#var fork_end := main_points[i] + fork_dir * (strike_pos - origin).length() * fork_length
			#var fork_points := _make_jagged_points(main_points[i], fork_end, int(segments * 0.5), jitter * 0.5)
#
			#var fork_line := Line2D.new()
			#fork_line.width = 2.0
			#fork_line.default_color = Color.CYAN
			#fork_line.points = fork_points
			#add_child(fork_line)
			#branch_lines.append(fork_line)

func _make_jagged_points(start: Vector2, end: Vector2, segments: int, jitter: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	var dir := end - start
	var step := dir / float(max(1, segments))
	var perp := Vector2(-dir.y, dir.x).normalized()
	for i in range(segments + 1):
		var base := start + step * i
		var offset = Vector2.ZERO;
		if(i > 0):
			offset = perp * rng.randf_range(-jitter, jitter)
		points.append(base + offset)
	return points

func _apply_damage(points: PackedVector2Array):
	var space := get_world_2d().direct_space_state
	for i in range(points.size() - 1):
		var seg := SegmentShape2D.new()
		seg.a = points[i]
		seg.b = points[i + 1]

		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = seg
		query.transform = global_transform
		query.collision_mask = 1  # adjust to Player’s layer

		var results := space.intersect_shape(query)
		for r in results:
			var body = r.collider
			if body.is_in_group("player") and body.has_method("take_damage"):
				body.take_damage(_damage)
				return  # damage only once


func trigger_lightning(lifetime: float):
	line_main.default_color = Color.WHITE
		# Damage check once
	_apply_damage(line_main.points)

	# Fade out
	var tween := create_tween()
	tween.tween_property(line_main, "modulate:a", 0.0, lifetime)
	for fork in branch_lines:
		tween.tween_property(fork, "modulate:a", 0.0, lifetime)
	tween.finished.connect(queue_free)
