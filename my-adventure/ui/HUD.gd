extends CanvasLayer

@onready var health_bar: TextureProgressBar = $VBoxContainer/HealthBar
@onready var mana_bar: TextureProgressBar = $VBoxContainer/ManaBar
@onready var health_label: Label = $HealthValue
@onready var mana_label: Label = $ManaValue
#@onready var spell_icons: HBoxContainer = $HUDSidebar/SpellIcons

# Keep references to each icon (assuming 3 slots)
@onready var spell_slots : = [
	$HUDSidebar/SpellIcons/SpellSlot1,
	$HUDSidebar/SpellIcons/SpellSlot2,
	$HUDSidebar/SpellIcons/SpellSlot3
]

func update_health(current: float, max: float):
	health_bar.max_value = max
	health_bar.value = current
	health_label.text = "%d / %d" % [current, max]

func update_mana(current: float, max: float):
	mana_bar.max_value = max
	mana_bar.value = current
	mana_label.text = "%d / %d" % [current, max]
	
# -- Spell UI Updates --
func update_spell_icons(equipped_spells: Array, active_slot: int):
	for i in range(spell_slots.size()):
		var icon = spell_slots[i].get_node("SpellIcon%d" % (i+1))
		var overlay = spell_slots[i].get_node("SpellIcon%d/CooldownOverlay" % (i+1))
		if i < equipped_spells.size() and equipped_spells[i]:
			var spell = equipped_spells[i]
			if spell.medium_icon:
				icon.texture = spell.medium_icon
			overlay.visible = true
		else:
			icon.texture = null
			overlay.visible = false

		icon.modulate = Color(1, 1, 1, 1 if i == active_slot else 0.4)
			
func update_spell_cooldowns(cooldowns: Dictionary, equipped_spells: Array):
	for i in range(spell_slots.size()):
		if i >= equipped_spells.size():
			continue
		var spell = equipped_spells[i]
		if not spell:
			continue

		var overlay = spell_slots[i].get_node("SpellIcon%d/CooldownOverlay" % (i+1))
		if spell.name in cooldowns:
			var remaining = cooldowns[spell.name]
			var total = spell.cooldown
			overlay.max_value = total
			overlay.value = total - remaining  # fill as cooldown expires
			overlay.visible = remaining > 0
		else:
			overlay.value = 0
			overlay.visible = false
