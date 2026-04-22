extends Node
class_name AttackManager

signal attack_started(step: int, type: String)
signal attack_finished(step: int, type: String)
signal attack_hit(enemy: Node, damage: int)

@onready var mana_manager: Node = $ManaSystem

@export var attack_area: Area2D
@export var attack_shape: CollisionShape2D
@export var shapes: Array[Resource]   # preload hitbox shapes
@export var offsets: Array[Vector2]   # preload hitbox offsets

@export var damage_per_attack := [10, 10, 15, 20, 15] # last one is jump attack

var active := false
var enemies_hit: Array = []
var current_step := 0
var current_type := "ground"

func _ready():
	if attack_area:
		attack_area.monitoring = false
		attack_area.body_entered.connect(_on_attack_area_body_entered)
		attack_area.area_entered.connect(_on_attack_area_area_entered)

func begin_attack(step: int, type: String = "ground"):
	current_step = step
	current_type = type
	enemies_hit.clear()
	emit_signal("attack_started", step, type)

	# Configure hitbox shape & offset
	if shapes.size() > step - 1:
		attack_shape.shape = shapes[step - 1]
	if offsets.size() > step - 1:
		var offset = offsets[step - 1]
		if get_parent().anim.flip_h:
			attack_area.position = -offset
		else:
			attack_area.position = offset

func activate_hitbox():
	if attack_area:
		attack_area.monitoring = true

func deactivate_hitbox():
	if attack_area:
		attack_area.monitoring = false

func end_attack():
	deactivate_hitbox()
	emit_signal("attack_finished", current_step, current_type)
	current_step = 0
	current_type = "ground"
	active = false

func _on_attack_area_body_entered(body: Node2D):
	if not attack_area.monitoring:
		return
	if body in enemies_hit:
		return
	if body.has_method("take_damage"):
		var dmg = _get_damage()
		body.take_damage(dmg)
		enemies_hit.append(body)
		emit_signal("attack_hit", body, dmg)

func _on_attack_area_area_entered(area: Area2D):
	var parent = area.get_parent()
	if not attack_area.monitoring:
		return
	if parent in enemies_hit:
		return
	if parent.has_method("take_damage"):
		var dmg = _get_damage()
		parent.take_damage(dmg)
		mana_manager.restore_mana_on_hit();
		enemies_hit.append(parent)
		emit_signal("attack_hit", parent, dmg)

func _get_damage() -> int:
	if current_type == "jump":
		return damage_per_attack[-1]  # last value
	elif current_step > 0 and current_step <= damage_per_attack.size():
		return damage_per_attack[current_step - 1]
	return 10
