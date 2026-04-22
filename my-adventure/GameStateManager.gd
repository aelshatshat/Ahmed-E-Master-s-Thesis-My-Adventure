extends Node

var player_data: Dictionary = {}
var defeated_bosses: Dictionary = {}
var completed_locations: Array = []
var boss_locations: Dictionary = {
	"celestial_primate" : "CelestialPrimatesDomain"
}
var inventory: Array = []
var active_quests: Array = []

# --- 🪄 Spell System ---
var unlocked_spells: Array[StringName] = []   # all available spell IDs or names
var equipped_spells: Array[StringName] = []   # up to 3 equipped spell names


# --- Initialization ---
func reset_state():
	print("[GameStateManager] Resetting game state...")

	player_data = {
		"name": "Ahmed",
		"health": 100,
		"max_health": 100,
		"position": Vector2.ZERO,
		"level": 1,
		"xp": 0
	}

	inventory.clear()
	active_quests.clear()
	defeated_bosses.clear()
	completed_locations.clear()

	# --- Initialize default spells ---
	unlocked_spells = ["Fireball", "Magic Explosion", "Magic Missilerack"]  # default unlocked spells
	equipped_spells = ["Fireball", "Magic Explosion", "Magic Missilerack"]  # default equipped (3 slots)

	print("[GameStateManager] Game state reset complete.")

# --- Player / Quest / Boss Management ---
func get_player_data() -> Dictionary:
	return player_data

func get_inventory() -> Array:
	return inventory

func get_active_quests() -> Array:
	return active_quests

func is_boss_defeated(id: String) -> bool:
	return defeated_bosses.get(id, false)

func mark_boss_defeated(id: String) -> void:
	defeated_bosses[id] = true
	var completed_location = boss_locations.get(id, null)
	if completed_location and not completed_locations.has(completed_location):
		completed_locations.append(completed_location)
	print("✅ Boss", id, "marked as defeated")


# --- 🪄 Spell Management ---

## Unlock a new spell by ID or name
func unlock_spell(spell_name: StringName) -> void:
	if not unlocked_spells.has(spell_name):
		unlocked_spells.append(spell_name)
		print("✨ Spell unlocked:", spell_name)
	else:
		print("Spell already unlocked:", spell_name)


## Check if a spell is unlocked
func is_spell_unlocked(spell_name: StringName) -> bool:
	return unlocked_spells.has(spell_name)


## Return all unlocked spells as resources (if needed)
func get_unlocked_spells() -> Array[Spell]:
	var spells: Array[Spell] = []
	for name in unlocked_spells:
		var path = _get_spell_resource_path(name)
		if path and ResourceLoader.exists(path):
			spells.append(load(path))
	return spells


## Get currently equipped spell resources
func get_equipped_spells() -> Array[Spell]:
	var spells: Array[Spell] = []
	for name in equipped_spells:
		var path = _get_spell_resource_path(name)
		if path and ResourceLoader.exists(path):
			spells.append(load(path))
	return spells


## Set new equipped spell lineup (accepts Spell resources or names)
func set_equipped_spells(spells: Array) -> void:
	equipped_spells.clear()
	for item in spells:
		if item is String or item is StringName:
			equipped_spells.append(item)
		elif item is Resource and item.has_method("get_name"):
			equipped_spells.append(item.name)
	print("🎒 Equipped spells updated:", equipped_spells)


# --- Internal Utility ---
## Maps spell names to resource paths
## You can extend this to use a data file later.
func _get_spell_resource_path(spell_name: StringName) -> String:
	var spell_map := {
		"Fireball": "res://spells/Fireball_Ins/FireballSpell.tres",
		"Magic Explosion": "res://spells/MagicExplosion_Com/ExplosionComboSpell.tres",
		"Magic Missilerack": "res://spells/MagicMissilerack_Inc/MagicMissilerack.tres"
	}
	return spell_map.get(spell_name, "")
