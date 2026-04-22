extends Resource
class_name BossPhase

@export var phase_name: String
@export var min_health_threshold: int
@export var attack_patterns: Array[Resource] = []
@export var mid_combat_event: Script = null  # Optional MCE script
