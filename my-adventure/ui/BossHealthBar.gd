extends CanvasLayer
class_name BossHealthBar

@onready var health_bar: TextureProgressBar = $Control/HealthBar
@onready var name_label: Label = $Control/BossName

func _ready() -> void:
	# Hide by default until a boss is set up
	visible = false


func setup_boss(boss_name: String, max_health: int):
	name_label.text = boss_name
	health_bar.max_value = max_health
	health_bar.value = max_health
	visible = true


func update_health(current: int, max: int):
	health_bar.max_value = max
	health_bar.value = current


func hide_bar():
	visible = false


# --- Helper for placeholder textures ---
func _make_placeholder(color: Color) -> Texture2D:
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(color)
	return ImageTexture.create_from_image(img)
