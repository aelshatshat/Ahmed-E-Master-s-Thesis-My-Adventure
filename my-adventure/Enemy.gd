extends CharacterBody2D

@export var max_health := 330
@export var move_speed := 0
@export var patrol_distance := 200

@onready var anim = $AnimatedSprite2D

var current_health := max_health
var direction := -1
var start_x := 0

func _ready():
	start_x = global_position.x
	anim.play("idle")

func _physics_process(delta):
	#if is_on_floor():
		#velocity.y = 0
	#else:
		#velocity.y += 1000 * delta  # gravity

	#patrol()
	move_and_slide()

#func patrol():
	#velocity.x = move_speed * direction
#
	#if abs(global_position.x - start_x) > patrol_distance:
		#direction *= -1
		#anim.flip_h = direction < 0

func _on_AnimatedSprite2D_animation_finished():
	if anim.animation == "hit":
		anim.play("idle")
		
func damage_player(player: Node, damage: int):
	if player.has_method("take_damage"):
		player.take_damage(damage)

func take_damage(amount):
	current_health -= amount
	flash_effect()
	#print("Enemy hit! Health:", current_health)
	if current_health <= 0:
		die()

func die():
	print("Enemy died.")
	queue_free()  # Later: add death animation
	
func flash_effect():
	var tween: Tween
	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_loops(3)  # Flash 3 times

	# Flash white and back to normal repeatedly
	tween.tween_property(anim, "modulate", Color.RED, 0.05)
	tween.tween_property(anim, "modulate", Color.WHITE, 0.05)
	tween.tween_property(anim, "modulate", Color(1, 1, 1, 1), 0.05)
