class_name Spell
extends Resource

@export var name: String = "Base Spell"
@export var mana_cost: float = 10.0
@export var cooldown: float = 1.0
@export var effect_scene: PackedScene
@export var small_icon: Texture2D
@export var medium_icon: Texture2D

func cast(caster: Node) -> void:
	# Base Spell does nothing
	print("Base Spell has no behavior.")
