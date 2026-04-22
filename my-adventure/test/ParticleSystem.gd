extends Node2D

@onready var particles: GPUParticles2D = $DustParticles
@onready var suction_zone: Area2D = $SuctionZone

@export var suction_strength: float = 4000.0
@export var suction_radius: float = 1000.0
@export var max_pull_force: float = 300.0

var suction_target: Vector2
var is_active: bool = false

func _ready():
	setup_particles()
	setup_suction_zone()
	
	# Connect signals
	suction_zone.body_entered.connect(_on_body_entered_suction_zone)
	suction_zone.area_entered.connect(_on_area_entered_suction_zone)
	
func setup_particles():
	var mat = ParticleProcessMaterial.new()
	
	mat.radial_velocity_max
	# Particles spawn in a circle around the suction point
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	mat.emission_sphere_radius = suction_radius

	# ✅ Negative radial accel → pulls toward the center
	mat.radial_accel_min = -suction_strength
	mat.radial_accel_max = -suction_strength * 1.2

	# No gravity
	mat.gravity = Vector3.ZERO

	# Make them fade as they approach
	mat.color = Color.BLACK
	mat.color_ramp = create_black_color_ramp()

	# Make them shrink toward the center
	mat.scale_min = 1.5
	mat.scale_max = 2
	mat.scale_curve = create_scale_curve()

	# Lifetime depends on radius (so particles reach the center before disappearing)
	particles.lifetime = suction_radius / suction_strength * 1.5
	mat.lifetime_randomness = 0.3
	
	# Assign to particles
	particles.process_material = mat
	particles.amount = 150
	particles.emitting = false
	particles.local_coords = false  # world space particles

func create_black_color_ramp() -> Gradient:
	var grad = Gradient.new()
	grad.add_point(0.0, Color(0, 0, 0, 1.0))   # Start opaque
	grad.add_point(0.7, Color(0, 0, 0, 0.6))   # Fade
	grad.add_point(1.0, Color(0, 0, 0, 0.0))   # Vanish at center
	return grad

func create_scale_curve() -> Curve:
	var c = Curve.new()
	c.add_point(Vector2(0.0, 1.0))  # start normal
	c.add_point(Vector2(0.7, 0.6))  # smaller near center
	c.add_point(Vector2(1.0, 0.0))  # vanish
	return c

func setup_suction_zone():
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = suction_radius
	
	if suction_zone.get_child_count() == 0:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = circle_shape
		suction_zone.add_child(collision_shape)
	else:
		suction_zone.get_child(0).shape = circle_shape
		
	suction_zone.monitoring = false

func start_suction(target_global_position: Vector2, duration: float = 3.0):
	suction_target = target_global_position
	global_position = suction_target
	is_active = true
	
	particles.global_position = suction_target
	particles.restart()
	particles.emitting = true
	suction_zone.monitoring = true
	
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		stop_suction()

func stop_suction():
	if not is_active:
		return
		
	is_active = false
	particles.emitting = false
	suction_zone.monitoring = false
	queue_free()

func _on_body_entered_suction_zone(body: Node2D):
	if is_active and body.has_method("apply_force"):
		_apply_suction_force(body)

func _on_area_entered_suction_zone(area: Area2D):
	if is_active:
		var parent = area.get_parent()
		if parent and parent.has_method("apply_force"):
			_apply_suction_force(parent)

func _apply_suction_force(target: Node2D):
	var direction = (global_position - target.global_position).normalized()
	var distance = global_position.distance_to(target.global_position)
	if distance == 0:
		return
		
	var distance_factor = clamp(1.0 - (distance / suction_radius), 0.0, 1.0)
	var force = max_pull_force * distance_factor
	
	if target is RigidBody2D:
		target.apply_central_force(direction * force)
	elif target is CharacterBody2D:
		target.velocity += direction * force * get_physics_process_delta_time()
	elif target.has_method("apply_force"):
		target.apply_force(direction * force)

# Public API
func is_suction_active() -> bool:
	return is_active

func set_suction_radius(new_radius: float):
	suction_radius = new_radius
	
	if suction_zone.get_child_count() > 0 and suction_zone.get_child(0).shape is CircleShape2D:
		suction_zone.get_child(0).shape.radius = new_radius
	
	if particles.process_material:
		particles.process_material.emission_sphere_radius = new_radius
