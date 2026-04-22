extends Control
class_name SafeZoneText

@export var glow_color: Color = Color(0, 0, 0, 1.0) # yellow-white glow
@export var glow_size: int = 4                       # size of the outline
@export var font_size: int = 32                      # default font size

func _ready():
	# Apply font overrides (so you don’t need a separate font resource yet)
	self.add_theme_font_size_override("font_size", font_size)

	# Add outer glow using outline
	self.add_theme_color_override("font_outline_color", glow_color)
	self.add_theme_constant_override("outline_size", glow_size)

	# Start invisible
	modulate.a = 0.0

func reset_colour(newFontColour : Color, newOutlineColour : Color):
	self.add_theme_color_override("font_outline_color", newOutlineColour)
	self.add_theme_color_override("font_color", newFontColour)

func show_text(text: String, duration: float = 2.0, pos: Vector2 = Vector2.ZERO):
	self.text = text
	global_position = pos

	var tween := create_tween()

	# Fade in
	tween.tween_property(self, "modulate:a", 1.0, 2).set_trans(Tween.TRANS_SINE)

	# Hold
	tween.tween_interval(duration)

	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_SINE)

	# Clean up
	tween.tween_callback(queue_free)
