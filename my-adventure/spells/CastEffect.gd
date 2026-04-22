extends Node2D

var cast_type = "instant"

func play_cast():
	if cast_type == "instant" or "no_mana":
		$AnimatedSprite2D.play(cast_type)
		await $AnimatedSprite2D.animation_finished
		queue_free()
	elif cast_type == "incantation":
		$AnimatedSprite2D.play(cast_type)

func end_cast():
	queue_free()
	
func set_type(type : String):
	if(type == "instant"):
		cast_type = type
	elif(type == "incantation"):
		cast_type = type
	elif(type == "no_mana"):
		cast_type = type
	else:
		push_warning("Not a type of spell")
