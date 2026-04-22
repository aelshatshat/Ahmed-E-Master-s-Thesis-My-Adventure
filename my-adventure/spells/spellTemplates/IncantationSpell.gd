class_name IncantationSpell
extends Spell

@export var cast_time: float = 1.5  # seconds to fully cast

func cast(caster: Node) -> void:
	print("Started incanting:", name)
	
	# Tell the SpellCaster to start an incantation sequence
	if caster.has_method("begin_incantation"):
		caster.begin_incantation(self, cast_time)
