extends Resource
class_name MovementTransition

@export_enum("Teleport", "Glide", "ArcGlide") var movement_type: String = "Teleport"
@export var target_anchor_name: String
