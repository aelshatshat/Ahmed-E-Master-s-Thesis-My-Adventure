extends Node2D

# Node references
@onready var suction_visual: ColorRect = $SuctionVisual
@onready var suction_zone: Area2D = $SuctionZone

# Suction properties
@export var suction_strength: float = 300.0
@export var suction_radius: float = 200.0
@export var duration: float = 3.0
@export var auto_start: bool = false

# Visual properties
@export var suction_color: Color = Color(0.3, 0.5, 1.0, 0.3)
@export var pulse_speed: float = 2.0

# Internal variables
var is_active: bool = false
var shader_material: ShaderMaterial
var affected_bodies: Array[Node2D] = []

func _ready():
	setup_suction_effect()
	
	# Connect signals
	suction_zone.body_entered.connect(_on_body_entered)
	suction_zone.area_entered.connect(_on_area_entered)
	
	if auto_start:
		start_suction()

func setup_suction_effect():
	# Create and configure the shader material
	shader_material = ShaderMaterial.new()
	var shader = preload("res:///test/chaos_zone_suction_effect/radial_suction_shader.gdshader")
	shader_material.shader = shader
	
	# Set initial shader parameters
	update_shader_parameters()
	
	# Apply material to visual
	suction_visual.material = shader_material
	
	# Configure suction zone size
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = suction_radius
	suction_zone.get_child(0).shape = circle_shape
	
	# Configure visual size (slightly larger than suction zone)
	suction_visual.size = Vector2(suction_radius * 2.2, suction_radius * 2.2)
	suction_visual.position = Vector2(-suction_radius * 1.1, -suction_radius * 1.1)
	
	# Start with effect disabled
	set_effect_intensity(0.0)
	suction_zone.monitoring = false
	suction_visual.color = Color.TRANSPARENT
	suction_visual.visible = false

func update_shader_parameters():
	if shader_material:
		shader_material.set_shader_parameter("suction_center", Vector2(0.5, 0.5))
		shader_material.set_shader_parameter("max_blur_radius", 0.1)
		shader_material.set_shader_parameter("suction_color", suction_color)
		shader_material.set_shader_parameter("pulse_speed", pulse_speed)
		shader_material.set_shader_parameter("ring_count", 3.0)

func _process(delta):
	if is_active and shader_material:
		# Update time for animations
		shader_material.set_shader_parameter("time", Time.get_time_dict_from_system())
		
		# Apply suction force to affected bodies
		apply_suction_forces(delta)

func start_suction(custom_duration: float = -1.0):
	if is_active:
		return
		
	is_active = true
	var actual_duration = custom_duration if custom_duration > 0 else duration
	
	# Enable effects
	suction_visual.visible = true
	suction_zone.monitoring = true
	
	# Animate suction appearing
	var appear_tween = create_tween()
	appear_tween.tween_method(set_effect_intensity, 0.0, 1.0, 0.5)
	appear_tween.set_ease(Tween.EASE_OUT)
	
	# Auto-stop after duration
	if actual_duration > 0:
		await get_tree().create_timer(actual_duration).timeout
		stop_suction()

func stop_suction():
	if not is_active:
		return
		
	is_active = false
	
	# Animate suction disappearing
	var disappear_tween = create_tween()
	disappear_tween.tween_method(set_effect_intensity, 1.0, 0.0, 0.5)
	disappear_tween.set_ease(Tween.EASE_IN)
	disappear_tween.tween_callback(cleanup_effect)

func set_effect_intensity(intensity: float):
	if shader_material:
		shader_material.set_shader_parameter("suction_intensity", intensity)

func cleanup_effect():
	# Disable effects
	suction_zone.monitoring = false
	suction_visual.visible = false
	affected_bodies.clear()

func _on_body_entered(body: Node2D):
	if is_active and body.has_method("apply_force") and not affected_bodies.has(body):
		affected_bodies.append(body)

func _on_area_entered(area: Area2D):
	if is_active:
		var parent = area.get_parent()
		if parent and parent.has_method("apply_force") and not affected_bodies.has(parent):
			affected_bodies.append(parent)

func apply_suction_forces(delta: float):
	for body in affected_bodies:
		if is_instance_valid(body):
			apply_suction_to_body(body, delta)
		else:
			affected_bodies.erase(body)

func apply_suction_to_body(body: Node2D, delta: float):
	var direction = (global_position - body.global_position).normalized()
	var distance = global_position.distance_to(body.global_position)
	
	# Calculate force strength (stronger when closer to center)
	var distance_factor = 1.0 - (distance / suction_radius)
	var force = suction_strength * distance_factor * delta
	
	# Apply force based on body type
	if body is RigidBody2D:
		body.apply_central_force(direction * force)
		
		# Add rotational force for spiral effect
		var tangent = direction.rotated(deg_to_rad(90))
		body.apply_torque(tangent.dot(direction) * force * 0.5)
		
	elif body is CharacterBody2D:
		body.velocity += direction * force
		
	elif body.has_method("apply_force"):
		body.apply_force(direction * force)

# Public API methods
func set_suction_radius(new_radius: float):
	suction_radius = new_radius
	if suction_zone.get_child(0).shape is CircleShape2D:
		suction_zone.get_child(0).shape.radius = new_radius
	suction_visual.size = Vector2(new_radius * 2.2, new_radius * 2.2)
	suction_visual.position = Vector2(-new_radius * 1.1, -new_radius * 1.1)

func set_suction_strength(new_strength: float):
	suction_strength = new_strength

func set_suction_color(new_color: Color):
	suction_color = new_color
	if shader_material:
		shader_material.set_shader_parameter("suction_color", new_color)

func is_suction_active() -> bool:
	return is_active

# Debug visualization
func _draw():
	if Engine.is_editor_hint() or OS.is_debug_build():
		draw_arc(Vector2.ZERO, suction_radius, 0, TAU, 32, Color.YELLOW, 2.0)
