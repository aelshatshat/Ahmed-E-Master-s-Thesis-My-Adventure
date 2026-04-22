extends Node2D  # or Control, depending on your setup

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# The name of the animation to play (exported for flexibility)
@export var animation_name: String = "cutscene_flow"

func _ready() -> void:
	if anim_player and anim_player.has_animation(animation_name):
		anim_player.play(animation_name)
		anim_player.animation_finished.connect(_on_animation_finished)
	else:
		push_warning("No animation named '%s' found on AnimationPlayer" % animation_name)
		queue_free()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == animation_name:
		queue_free()
