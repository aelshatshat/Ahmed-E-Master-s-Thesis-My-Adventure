extends Area2D

@export var speed: float = 400.0
@export var damage: int = 25
@export var turn_rate: float = 4.0
@export var impact_radius: float = 40.0
@export var max_lifetime: float = 15.0

var target_position: Vector2
var target: Node2D
var direction := Vector2.RIGHT
var time_alive : float = 0.0
var homing_enabled := true

@onready var anim = $AnimatedSprite2D

func set_target(pos: Vector2, player: Node2D):
	target_position = pos
	target = player;
	direction = (target_position - global_position).normalized()

func _ready():
	anim.play("fall")
	look_at(global_position + direction)

func _physics_process(delta):
	time_alive += delta
	if time_alive > max_lifetime:
		queue_free()
		return
	if(time_alive < 0.1):
		direction = Vector2.UP  # Force upward movement
		homing_enabled = false
	elif(0.1 < time_alive and time_alive < 1.5):
		homing_enabled = true;
	else:
		homing_enabled = false;
	# Loosely home toward target
	if homing_enabled:
		target_position = target.global_position
		var desired = (target_position - global_position).normalized()
		direction = direction.lerp(desired, delta * turn_rate).normalized()

	# Move
	global_position += direction * speed * delta

	# Rotate the meteor to face its movement direction
	rotation = direction.angle() + deg_to_rad(90) *-1

	## Check proximity for explosion
	#if global_position.distance_to(target_position) <= impact_radius:
		#explode()


func explode():
	anim.play("impact")
	check_player_damage()
	set_physics_process(false)
	await get_tree().create_timer(0.3).timeout
	queue_free()

func check_player_damage():
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage(damage)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		explode()
	elif body.is_in_group("enemy"):
		pass;
	else:
		explode()
