class_name ExplosionComboSpell
extends ComboSpell

@export var explosion_scene: PackedScene  # the base explosion effect
@export var explosion_scene2: PackedScene  # the area explosion effect
@export var upward_explosion_scene: PackedScene  # the upward explosion effect
@export var big_explosion_scene: PackedScene  # the upward explosion effect
@export var step_patterns: Array[String] = [
	"single",    # step 1: one explosion
	"forward",   # step 2: chain forward
	"upward",    # step 3: chain upward
	"big"     # step 4: big explosion
]
@export var step_counts: Array[int] = [1, 4, 4, 8] # how many explosions per step
@export var step_displacements: Array[int] = [0, 10, -20, 5] # how many explosions per step
@export var vertical_step_displacements: Array[int] = [0, 20, -20, 10] # how many explosions per step

var world_parent: Node = null

func set_world_parent(parent: Node):
	world_parent = parent

func cast_combo_step(step: int, caster: Node2D, facing_dir: int):
	if step < 1 or step > step_patterns.size():
		push_warning("Invalid combo step %d" % step)
		return
	
	var pattern = step_patterns[step - 1]
	var count = step_counts[step - 1]
	var start_pos = caster.global_position
	match pattern:
		"single":
			_spawn_single(start_pos + Vector2(35 * facing_dir, 35), facing_dir)
		"forward":
			await _spawn_chain_forward(start_pos + Vector2(35 * facing_dir, 35), facing_dir, count, caster)
		"upward":
			await _spawn_chain_upward(start_pos + Vector2(50 * facing_dir, 50), count, caster)
		"big":
			await _spawn_big(start_pos + Vector2(75 * facing_dir, 20))

# Explosion patterns

func _spawn_single(position: Vector2, isFlipped: int):
	_spawn_explosion(position, isFlipped)

func _spawn_chain_forward(start_pos: Vector2, direction: int, count: int, caster: Node, delay := 0.1):
	
	for i in count:
		await caster.get_tree().create_timer(delay * i).timeout
		_spawn_explosion_area(start_pos + Vector2(30 * i * direction, step_displacements[i]))

func _spawn_chain_upward(start_pos: Vector2, count: int, caster: Node, delay := 0.1):
	for i in count:
		await caster.get_tree().create_timer(delay * i).timeout
		if(i <= 2):
			_spawn_explosion_area(start_pos + Vector2(vertical_step_displacements[i] , -20 * i))
		else:
			_spawn_explosion_upward(start_pos + Vector2(vertical_step_displacements[i] , -20 * i))


func _spawn_big(position: Vector2):
	_spawn_big_explosion(position)
	
func _spawn_explosion(position: Vector2, isFlipped: int):
	if not explosion_scene:
		push_warning("No explosion scene assigned!")
		return
	
	if world_parent:
		var e = explosion_scene.instantiate()
		if(isFlipped < 0):
			e.flip_explosion()
		e.global_position = position
		world_parent.add_child(e)
		
func _spawn_explosion_area(position: Vector2):
	if not explosion_scene2:
		push_warning("No explosion scene assigned!")
		return
	
	if world_parent:
		var e = explosion_scene2.instantiate()
		e.global_position = position
		world_parent.add_child(e)
		
func _spawn_explosion_upward(position: Vector2):
	if not upward_explosion_scene:
		push_warning("No explosion scene assigned!")
		return
	
	if world_parent:
		var e = upward_explosion_scene.instantiate()
		e.global_position = position
		world_parent.add_child(e)
		
func _spawn_big_explosion(position: Vector2):
	if not big_explosion_scene:
		push_warning("No explosion scene assigned!")
		return
	
	if world_parent:
		var e = big_explosion_scene.instantiate()
		e.global_position = position
		world_parent.add_child(e)
