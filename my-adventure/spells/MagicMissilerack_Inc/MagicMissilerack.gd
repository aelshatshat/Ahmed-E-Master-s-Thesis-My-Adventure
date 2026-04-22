extends Node2D
class_name MagicMissilerack

@export var missile_scene: PackedScene
@export var missile_count: int = 20
@export var fire_interval: float = 0.1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var tube_positions: Array[Vector2] = []
var rng := RandomNumberGenerator.new()

var is_ready_to_fire := false
var player: Node2D = null
var direction = 1;

func set_direction(dir: int) -> void:
	# Flip sprite if needed
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = dir < 0
		direction = dir
		
func _ready():
	rng.randomize()
	var spacing_x := 5
	var spacing_y := 5
	for i in range(4):
		for j in range(5):
			tube_positions.append(Vector2(i * spacing_x, j * spacing_y))    # right side
			tube_positions.append(Vector2(-i * spacing_x, j * spacing_y))   # left side
	modulate.a = 0.0

func begin_cast(cast_time: float, owner: Node2D) -> void:
	player = owner
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, cast_time)

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position + Vector2(-5 * direction, 25) # offset behind them

func start_firing():
	if is_ready_to_fire: return
	is_ready_to_fire = true
	_spawn_missiles()

func _spawn_missiles() -> void:
	for i in range(missile_count):
		if not missile_scene:
			break
		var tube_pos = tube_positions.pick_random()
		var missile = missile_scene.instantiate()
		missile.global_position = global_position + tube_pos - Vector2(0,10)
		get_parent().add_child(missile)
		await get_tree().create_timer(fire_interval).timeout

	# Fade out after firing
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.finished.connect(queue_free)

func cancel():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "queue_free"))
