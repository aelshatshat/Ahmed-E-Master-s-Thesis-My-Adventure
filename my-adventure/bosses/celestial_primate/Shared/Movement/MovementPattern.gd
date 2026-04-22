# res://bosses/celestial_primate/Shared/MovementPattern.gd
class_name MovementPattern
extends Resource

## Base resource class for all movement patterns
## Inheritors: TeleportMovement, GlideMovement, etc.

@export var duration: float = 1.0  # generic movement duration

func execute(boss: Node2D, player: Node2D, from_anchor: BossAnchor, to_anchor: BossAnchor) -> void:
	pass
