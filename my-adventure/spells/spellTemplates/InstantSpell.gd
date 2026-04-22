class_name InstantSpell
extends Spell

func cast(caster: Node) -> void:
	print("%s casted instantly!" % name)
	
	# Get the actual player Node2D (assuming SpellCaster is a child of Player)
	var player = caster.get_parent() as Node2D
	
	if effect_scene:
		var effect = effect_scene.instantiate()
		
		# Determine facing direction based on player flip
		var direction := 1
		if player.has_node("AnimatedSprite2D"):
			var anim_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
			direction = -1 if anim_sprite.flip_h else 1
		
		# Spawn in front of player
		effect.global_position = player.global_position + Vector2(40 * direction, 35)
		
		# If the projectile can take a direction, give it one
		if effect.has_method("set_direction"):
			effect.set_direction(direction)
		
		player.get_parent().add_child(effect)
