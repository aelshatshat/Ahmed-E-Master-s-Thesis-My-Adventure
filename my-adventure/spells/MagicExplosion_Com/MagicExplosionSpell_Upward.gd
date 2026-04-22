extends Node2D

@export var damage := 15
@onready var attack_area = $UpwardExplosion

func _ready():
	$AnimatedSprite2D.play("explosion_attack3")
	await $AnimatedSprite2D.animation_finished
	queue_free()

#func _on_upward_explosion_body_entered(body: Node2D) -> void:
	#if body.has_method("take_damage"):
		#body.take_damage(damage)

func _on_upward_explosion_area_entered(body: Area2D) -> void:
	var parentBody = body.get_parent()
	if parentBody.has_method("take_damage"):
		parentBody.take_damage(damage)

func activate_attack_hitbox():
	attack_area.monitoring = true

func deactivate_attack_hitbox():
	attack_area.monitoring = false

func _on_animated_sprite_2d_frame_changed() -> void:
	var anim = $AnimatedSprite2D
	var current_anim = anim.animation
	var frame = anim.frame
	
	match current_anim:
		"explosion_attack3":
			match frame:
				5:
					activate_attack_hitbox()  # active hit window
				8:
					deactivate_attack_hitbox() # end hit window
