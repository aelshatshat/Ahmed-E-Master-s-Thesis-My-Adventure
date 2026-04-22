extends Area2D

@export var damage: int = 25
@export var delay_before_eruption: float = 0.6
@export var active_duration: float = 2

var has_damaged := false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	anim.play("telegraph")
	collision.disabled = true
	await get_tree().create_timer(delay_before_eruption).timeout
	await spin_up()   # ✅ ensure spin_up completes before erupt
	await erupt()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and not has_damaged:
		if body.has_method("take_damage") and not body.is_player_invulnerable():
			body.take_damage(damage)
			has_damaged = true

func spin_up() -> void:
	anim.play("spin_up")
	await anim.animation_finished  # ✅ wait for spin_up to finish

func spin_down() -> void:
	anim.play("spin_down")
	await anim.animation_finished  # ✅ wait for spin_down to finish

func erupt() -> void:
	anim.play("spin")
	collision.disabled = false
	has_damaged = false

	await get_tree().create_timer(active_duration).timeout
	collision.disabled = true
	await spin_down()   # ✅ ensures full spin_down before freeing
	queue_free()
