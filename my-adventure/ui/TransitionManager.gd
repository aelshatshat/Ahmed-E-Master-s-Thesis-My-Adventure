extends CanvasLayer

@onready var rect: ColorRect = ColorRect.new()
var _tween: Tween

func _ready():
	# Configure the fade rectangle
	rect.color = Color(0, 0, 0, 0)  # fully transparent at start
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # 🚀 lets clicks pass through
	add_child(rect)

	# Ensure this layer stays above everything else
	layer = 100

	# Add to the scene tree root so it persists globally
	get_tree().root.add_child(self)

func fade_in(duration: float = 1.0) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(rect, "color:a", 1.0, duration)
	await _tween.finished

func fade_out(duration: float = 1.0) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(rect, "color:a", 0.0, duration)
	await _tween.finished
