extends TextureButton
class_name SpellTile

@onready var icon = $TextureRect
@onready var label = $Label

var spell: Spell
var is_selected: bool = false

signal clicked(tile)
signal dragged(tile)
signal dropped(tile)

func setup(spell_data: Spell):
	spell = spell_data
	$TextureRect.texture = spell.medium_icon
	$Label.text = spell.name

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.is_action_pressed("ui_drag"):
			emit_signal("dragged", self)
		else:
			emit_signal("clicked", self)
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("dropped", self)

func set_selected(selected: bool):
	is_selected = selected
	self.modulate = Color(1, 1, 1, 1) if selected else Color(0.8, 0.8, 0.8, 1)
