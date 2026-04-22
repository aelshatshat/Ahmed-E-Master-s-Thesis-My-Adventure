extends Control

@onready var available_grid: GridContainer = $PanelContainer/VBoxContainer/AvailableSpells
@onready var equipped_grid: HBoxContainer = $PanelContainer/VBoxContainer/EquippedSpells
@onready var close_button: Button = $Button

var all_spells: Array[Spell] = []
var equipped_spells: Array[Spell] = []

var selected_tile: SpellTile = null

signal spells_updated(new_equipped_spells: Array[Spell])

func open():
	visible = true
	_load_spell_data()
	close_button.pressed.connect(close_menu)

func _load_spell_data():
	var gsm = GameStateManager  # or your spell inventory system
	all_spells = gsm.get_unlocked_spells()
	equipped_spells = gsm.get_equipped_spells()
	
	_populate_grids()

func _populate_grids():
	# Clear properly
	for child in available_grid.get_children():
		child.queue_free()
	for child in equipped_grid.get_children():
		child.queue_free()
	
	# Set GridContainer columns (adjust as needed)
	available_grid.columns = 4
	
	for spell in all_spells:
		var tile = _create_spell_tile(spell)
		available_grid.add_child(tile)
	
	for spell in equipped_spells:
		var tile = _create_spell_tile(spell)
		equipped_grid.add_child(tile)
	
	# Force layout update
	available_grid.queue_sort()
	equipped_grid.queue_sort()

# --- Interaction logic ---
func _on_tile_clicked(tile: SpellTile):
	if not selected_tile:
		selected_tile = tile
		tile.set_selected(true)
	else:
		if tile == selected_tile:
			tile.set_selected(false)
			selected_tile = null
			return
		_swap_spells(selected_tile, tile)
		selected_tile.set_selected(false)
		selected_tile = null

func _on_tile_dragged(tile: SpellTile):
	selected_tile = tile

func _on_tile_dropped(target: SpellTile):
	if selected_tile and target and selected_tile != target:
		_swap_spells(selected_tile, target)
	selected_tile = null

func _swap_spells(tile_a: SpellTile, tile_b: SpellTile):
	var spell_a = tile_a.spell
	var spell_b = tile_b.spell

	var a_in_equipped = tile_a.get_parent() == equipped_grid
	var b_in_equipped = tile_b.get_parent() == equipped_grid

	if a_in_equipped and not b_in_equipped:
		var idx = equipped_grid.get_children().find(tile_a)
		equipped_spells[idx] = spell_b
	elif b_in_equipped and not a_in_equipped:
		var idx = equipped_grid.get_children().find(tile_b)
		equipped_spells[idx] = spell_a
	elif a_in_equipped and b_in_equipped:
		var idx_a = equipped_grid.get_children().find(tile_a)
		var idx_b = equipped_grid.get_children().find(tile_b)
		equipped_spells[idx_a] = spell_b
		equipped_spells[idx_b] = spell_a
	
	_populate_grids()
	emit_signal("spells_updated", equipped_spells)

func _create_spell_tile(spell: Spell) -> SpellTile:
	var tile = preload("res://ui/world_objects/spell_swap/SpellTile.tscn").instantiate()
	tile.setup(spell)
	tile.clicked.connect(_on_tile_clicked)
	tile.dragged.connect(_on_tile_dragged)
	tile.dropped.connect(_on_tile_dropped)
	return tile

func close_menu():
	queue_free()
