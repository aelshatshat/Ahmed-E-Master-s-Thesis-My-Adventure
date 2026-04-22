class_name ComboSpell
extends Spell

# Optional extra elemental damage
@export var extra_damage: int = 10

func cast(caster: Node) -> void:
	print("%s triggered as combo spell!" % name)
	
	# Tell SpellCaster to trigger a magic combo hit
	if caster.has_method("begin_combo_spell"):
		caster.begin_combo_spell(self, extra_damage)
