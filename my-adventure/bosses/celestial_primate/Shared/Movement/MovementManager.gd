extends Node
class_name MovementManager

@export var movement_patterns: Array[Resource] = []
@export var anchors: Array[BossAnchor] = []

var current_anchor: BossAnchor = null
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	movement_patterns[0].set_name("ArcGlide")
	movement_patterns[1].set_name("Glide")
	movement_patterns[2].set_name("Teleport")
	# Optional: auto-collect anchors from scene
	if anchors.is_empty():
		anchors = []
		for node in get_tree().get_nodes_in_group("boss_anchor"):
			if node is BossAnchor:
				anchors.append(node)
	# Start at first anchor
	if not anchors.is_empty() and current_anchor == null:
		for node in get_tree().get_nodes_in_group("MCE_anchor"):
			current_anchor = node

func perform_movement(boss: Node2D, player: Node2D) -> void:
	if not current_anchor or movement_patterns.is_empty():
		return
	# Gather all possible transitions from current anchor
	var all_transitions: Array[MovementTransition] = current_anchor.transitions
	if all_transitions.is_empty():
		return

	# Pick a random transition
	var choice: MovementTransition = all_transitions.pick_random()

	# Find the movement pattern that matches this transition type
	var move_pattern: MovementPattern = null
	for p in movement_patterns:
		if p.get_name() == choice.movement_type:
			move_pattern = p
			break

	if not move_pattern:
		return

	# Resolve target anchor by name from group
	var target_anchor: BossAnchor = null
	for node in get_tree().get_nodes_in_group("boss_anchor"):
		if node.name == choice.target_anchor_name:
			target_anchor = node
			break
	if not target_anchor:
		push_warning("MovementManager: could not find anchor named %s" % choice.target_anchor_name)
		return

	
	# Run movement
	await move_pattern.execute(boss, player, current_anchor, target_anchor)

	# Update current anchor
	current_anchor = target_anchor
	
func perform_special_movement(boss: Node2D, player: Node2D) -> void:
	var target_anchor: BossAnchor = null

	for node in get_tree().get_nodes_in_group("MCE_anchor"):
		target_anchor = node
	var move_pattern: MovementPattern = movement_patterns[2]
	await move_pattern.execute(boss, player, self.current_anchor, target_anchor)
	current_anchor = target_anchor
