extends Node2D

@export var damage := 15
@onready var attack_area = $ForwardExplosion

func _ready():
	activate_attack_hitbox()  # active hit window
	$AnimatedSprite2D.play("explosion_attack1")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_forward_explosion_area_entered(body: Area2D) -> void:
	var parentBody = body.get_parent()
	if parentBody.has_method("take_damage"):
		parentBody.take_damage(damage)

func activate_attack_hitbox():
	attack_area.monitoring = true

func deactivate_attack_hitbox():
	attack_area.monitoring = false

func flip_explosion():
	var anim = $AnimatedSprite2D
	anim.flip_h = true;

func _on_animated_sprite_2d_frame_changed() -> void:
	var anim = $AnimatedSprite2D
	var current_anim = anim.animation
	var frame = anim.frame
	
	match current_anim:
		"explosion_attack1":
			match frame:
				3:
					deactivate_attack_hitbox() # end hit window
