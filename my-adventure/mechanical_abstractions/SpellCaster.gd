extends Node

@onready var mana_system: Node = get_node("../AttackManager/ManaSystem")
# 🔥 Support multiple spell slots
@export var equipped_spells: Array[Spell] = [] # up to 3
@export var swap_cooldown: float = 0.5         # cooldown between swaps
@export var cast_effect_scene: PackedScene
@export var magic_circle_scene: PackedScene
@export var incantation_progress_scene: PackedScene

var incantation_progress: ProgressBar = null

var active_slot: int = 0
var swap_timer: float = 0.0

var spell_cooldowns := {} # { spell_name: remaining_time }


var cooldown_timer: float = 0.0
var is_casting: bool = false
var current_incantation_spell: IncantationSpell = null
var cast_timer: float = 0.0
var active_combo_spell: ComboSpell = null  # next combo attack will be magical

var effect = null
var cast_effect: Node2D = null
var magic_circle_effect: Node2D = null

signal active_spell_changed(equipped_spells, active_slot)
signal spell_cooldowns_updated(cooldowns: Dictionary)

func _process(delta: float) -> void:
	# Swap cooldown
	if swap_timer > 0.0:
		swap_timer -= delta

	# Per-spell cooldown updates
	var updated := false
	for spell_name in spell_cooldowns.keys():
		spell_cooldowns[spell_name] = max(spell_cooldowns[spell_name] - delta, 0)
		updated = true

	if updated:
		emit_signal("spell_cooldowns_updated", spell_cooldowns)
	
	if(cast_effect):
		cast_effect.global_position = get_parent().global_position + Vector2(0, 45)

	# Incantation logic
	if is_casting:
		cast_timer -= delta
		if incantation_progress:
			var ratio = 1.0 - (cast_timer / current_incantation_spell.cast_time)
			incantation_progress.value = clamp(ratio, 0.0, 1.0)
			# Keep it above player
			#if is_instance_valid(get_parent()):
				#incantation_progress.global_position = get_parent().global_position + Vector2(0, -60)
			
		if cast_timer <= 0:
			_finish_incantation()
		return

	# 🔥 Spell slot swapping
	if Input.is_action_just_pressed("spell_slot_1"):
		_set_active_slot(0)
	elif Input.is_action_just_pressed("spell_slot_2"):
		_set_active_slot(1)
	elif Input.is_action_just_pressed("spell_slot_3"):
		_set_active_slot(2)

# --- Core Casting ---
func cast_spell() -> void:
	if equipped_spells.is_empty() or active_slot >= equipped_spells.size():
		return

	var spell: Spell = equipped_spells[active_slot]
	if not spell:
		return

	# Prevent casting while spell is cooling down
	if spell.name in spell_cooldowns and spell_cooldowns[spell.name] > 0:
		print("Spell on cooldown:", spell.name)
		return

	var spell_cost = spell.mana_cost
	if not mana_system.can_cast(spell_cost):
		cast_effect = cast_effect_scene.instantiate()
		cast_effect.set_type("no_mana")
		add_child(cast_effect)
		cast_effect.play_cast()
		return
	
	get_parent().emit_signal("spell_casted", spell.name)
	
	if not (spell is ComboSpell):
		mana_system.spend_mana(spell_cost)
		spell_cooldowns[spell.name] = spell.cooldown

	# proceed with casting logic...
	if spell is InstantSpell:
		cast_effect = cast_effect_scene.instantiate()
		add_child(cast_effect)
		cast_effect.global_position = get_parent().global_position + Vector2(0, 45)
		spell.cast(self)
		cast_effect.play_cast()
		
	elif spell is IncantationSpell:
		magic_circle_effect = magic_circle_scene.instantiate()
		add_child(magic_circle_effect)
		cast_effect = cast_effect_scene.instantiate()
		cast_effect.set_type("incantation")
		add_child(cast_effect)
		cast_effect.global_position = get_parent().global_position + Vector2(0, 45)
		magic_circle_effect.global_position = get_parent().global_position + Vector2(0, 50)
		cast_effect.play_cast()
		magic_circle_effect.play_cast()
		begin_incantation(spell as IncantationSpell, spell.cast_time)
	elif spell is ComboSpell:
		active_combo_spell = spell


# --- Slot Management ---
func _set_active_slot(index: int) -> void:
	if swap_timer > 0.0:
		print("⏳ Can't swap spells yet!")
		return
	if index < 0 or index >= equipped_spells.size():
		return
	if index == active_slot:
		return

	active_slot = index
	swap_timer = swap_cooldown
	
	emit_signal("active_spell_changed", equipped_spells, active_slot)

	var spell: Spell = equipped_spells[active_slot]
	#print("🔄 Switched to spell slot:", index + 1, "(", spell.name, ")")

	# Spawn swap icon above player
	var player = get_parent()
	if player:
		var icon_scene := preload("res://ui/SpellSwapIcon.tscn")
		var icon := icon_scene.instantiate() as SpellSwapIcon
		# add to same parent as player (so global_position makes sense)
		player.get_parent().add_child(icon)
		# now safe to setup and pass the player so it follows
		icon.setup(spell, player, Vector2(0, 15))


# --- Incantation Spell Support ---
func begin_incantation(spell: IncantationSpell, duration: float) -> void:
	is_casting = true
	current_incantation_spell = spell
	cast_timer = duration

	var player = get_parent()
	if player.has_method("lock_movement"):
		player.lock_movement(true)

	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("cast")
	
	# Spawn the incantation progress bar
	if incantation_progress_scene:
		incantation_progress = incantation_progress_scene.instantiate()
		player.get_parent().add_child(incantation_progress)
		incantation_progress.value = 0.0
		# Position above player
		incantation_progress.global_position = player.global_position + Vector2(-40, -10)
	
	# NEW: Spawn the effect scene immediately
	if current_incantation_spell and current_incantation_spell.effect_scene:
		# Determine facing direction based on player flip
		var direction : int = assessDirection()
		
		effect = current_incantation_spell.effect_scene.instantiate()
		effect.global_position = player.global_position + Vector2(-5 * direction, 25)
		player.get_parent().add_child(effect)

		# If the effect can take a direction, give it one
		if effect.has_method("set_direction"):
			effect.set_direction(direction)
		# If it’s the rack, let it know the cast time
		if effect.has_method("begin_cast"):
			effect.begin_cast(duration, player)  # pass player reference


func _finish_incantation() -> void:
	is_casting = false
	if incantation_progress and is_instance_valid(incantation_progress):
		incantation_progress.queue_free()
		incantation_progress = null

	cast_effect.end_cast()
	magic_circle_effect.end_cast()
	var player = get_parent()
	if player.has_method("lock_movement"):
		player.lock_movement(false)
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("idle")

	if current_incantation_spell and current_incantation_spell.effect_scene:
		# The rack was already spawned — just trigger its firing
		for child in player.get_parent().get_children():
			if child is MagicMissilerack:
				child.start_firing()
				break

	print("Incantation completed:", current_incantation_spell.name)
	current_incantation_spell = null


func cancel_cast():
	if not is_casting:
		return

	is_casting = false
	cast_timer = 0.0
	current_incantation_spell = null
	if incantation_progress and is_instance_valid(incantation_progress):
		incantation_progress.queue_free()
		incantation_progress = null
	cast_effect.end_cast()
	magic_circle_effect.end_cast()

	var player = get_parent()
	if player.has_method("lock_movement"):
		player.lock_movement(false)

	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("idle")

	# If we already spawned an effect (e.g., MagicMissilerack), clean it up
	if effect and is_instance_valid(effect):
		if effect.has_method("cancel"): 
			effect.cancel()  # Let the effect handle its own cleanup (optional)
		else:
			effect.queue_free()
		effect = null

	print("❌ Incantation canceled!")


# --- Combo Spell Support ---
func trigger_combo_spell_step(step: int, caster: Node2D, facing_dir: int):
	if active_combo_spell:
		active_combo_spell.set_world_parent(caster.get_parent())
		active_combo_spell.cast_combo_step(step, caster, facing_dir)
		mana_system.spend_mana(active_combo_spell.mana_cost)
		# Uncomment if you want it to only last for 1 hit:
		# active_combo_spell = null

func assessDirection():
	var player = get_parent()
	if player.has_node("AnimatedSprite2D"):
			var anim_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
			return -1 if anim_sprite.flip_h else 1
