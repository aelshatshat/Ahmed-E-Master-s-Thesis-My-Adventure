extends Sprite2D

# Shader parameters
@export var vortex_strength: float = 0.5 : set = _set_vortex_strength
@export var vortex_radius: float = 0.5 : set = _set_vortex_radius
@export var spin_speed: float = 2.0 : set = _set_spin_speed
@export var vortex_color: Color = Color(0.3, 0.5, 1.0, 0.8) : set = _set_vortex_color

@onready var shader_material: ShaderMaterial = self.material

func _ready():
	var base_texture = create_solid_texture(256, 256, Color.BLUE)

	self.texture = base_texture  # Required!
	# Ensure we have a shader material
	if not shader_material:
		push_error("VortexSprite requires a ShaderMaterial with vortex_shader")
		return
	
	# Load noise texture (you can create one in Godot or use a simple texture)
	var noise_texture = _create_noise_texture()
	shader_material.set_shader_parameter("noise_texture", noise_texture)
	
	# Set initial shader values
	update_shader_parameters()

func _create_noise_texture() -> NoiseTexture2D:
	# Create a simple noise texture for distortion
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 2.0
	
	var noise_texture = NoiseTexture2D.new()
	noise_texture.noise = noise
	noise_texture.width = 256
	noise_texture.height = 256
	noise_texture.in_3d_space = false
	
	return noise_texture

func _process(delta):
	if shader_material:
		# Animate the vortex
		var current_time = Time.get_time_dict_from_system()
		shader_material.set_shader_parameter("time", current_time)

func update_shader_parameters():
	if shader_material:
		shader_material.set_shader_parameter("strength", vortex_strength)
		shader_material.set_shader_parameter("radius", vortex_radius)
		shader_material.set_shader_parameter("time_speed", spin_speed)
		shader_material.set_shader_parameter("vortex_color", vortex_color)
		shader_material.set_shader_parameter("center", Vector2(0.5, 0.5))

func create_solid_texture(width: int, height: int, color: Color) -> ImageTexture:
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)

# Property setters for Inspector control
func _set_vortex_strength(value: float):
	vortex_strength = clamp(value, 0.0, 2.0)
	update_shader_parameters()

func _set_vortex_radius(value: float):
	vortex_radius = clamp(value, 0.0, 1.0)
	update_shader_parameters()

func _set_spin_speed(value: float):
	spin_speed = clamp(value, 0.0, 10.0)
	update_shader_parameters()

func _set_vortex_color(value: Color):
	vortex_color = value
	update_shader_parameters()

# Public methods for animation
func start_vortex(duration: float = 3.0):
	# Animate vortex appearing
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(_animate_strength, 0.0, vortex_strength, 0.5)
	tween.tween_method(_animate_radius, 0.0, vortex_radius, 0.7)
	
	# Auto-stop
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		stop_vortex()

func stop_vortex():
	# Animate vortex disappearing
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(_animate_strength, vortex_strength, 0.0, 0.5)
	tween.tween_method(_animate_radius, vortex_radius, 0.0, 0.3)
	tween.tween_callback(queue_free)

func _animate_strength(value: float):
	vortex_strength = value
	update_shader_parameters()

func _animate_radius(value: float):
	vortex_radius = value
	update_shader_parameters()

# Function to create suction force on objects
func apply_suction_force_to_body(body: Node2D, force_strength: float = 100.0):
	var direction = (global_position - body.global_position).normalized()
	var distance = global_position.distance_to(body.global_position)
	
	# Stronger force when closer to vortex center
	var distance_factor = 1.0 - (distance / (texture.get_size().x * scale.x * 0.5))
	var force = force_strength * distance_factor
	
	if body is RigidBody2D:
		body.apply_central_force(direction * force)
	elif body is CharacterBody2D:
		body.velocity += direction * force * get_physics_process_delta_time()
