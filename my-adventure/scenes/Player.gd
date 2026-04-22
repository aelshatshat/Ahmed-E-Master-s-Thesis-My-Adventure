extends CharacterBody2D

@export var speed := 200.0

@export var jump_velocity := -500.0
@export var gravity := 1000.0
@export var max_jump_time := 0.25          # how long you can hold to extend jump
@export var sustain_boost := -500.0        # extra upward force while holding
@export var jump_dampening := 0.5          # short hop multiplier
@export var peak_gravity_multiplier := 2.0 # stronger gravity near peak

@export var attack_cooldown := 0.5
@export var magic_circle_scene: PackedScene

@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D

@onready var health_manager: Node = $HealthManager
@onready var mana_manager: Node = $AttackManager/ManaSystem
@onready var status_effects: StatusEffectManager = $StatusEffects
@onready var attack_manager: AttackManager = $AttackManager

@onready var dodge_caster = $DodgeCaster
@onready var spell_caster = $SpellCaster

var hud: CanvasLayer = null

var movement_locked = false

var force_idle := false
var attack_unlock_timer := 0.0

var special_anim_playing := false;
var magic_circle_effect: Node2D = null

# Sizes for each attack (width x height)
var attack_shapes : Array[Resource] = [
	preload("res://hitboxes/attack1_shape.tres"),
	preload("res://hitboxes/attack2_shape.tres"),
	preload("res://hitboxes/attack3_shape.tres"),
	preload("res://hitboxes/attack4_shape.tres"),
	preload("res://hitboxes/jump_attack_shape.tres")
]

# Optional offsets to extend reach for later swings
var hitbox_offsets : Array[Vector2] = [
	Vector2(30, 0),   # attack1
	Vector2(30, 0),   # attack2
	Vector2(20, 0),   # attack3
	Vector2(15, 0),   # attack4
	Vector2(0, 15)   # jump_attack
]

#--------# Player State and Movement #--------# 

var is_attacking := false
var is_jump_attacking := false
var is_dodging := false;
var dodge_velocity := Vector2.ZERO
var maxJumps := 2;
var jumpsLeft := maxJumps;
var external_forces := Vector2.ZERO
var jump_time := 0.0
var is_jumping := false
var gravity_multi := 1
var current_jump_pos: Vector2


#--------# Combo System #--------# 

var combo_step := 0
var next_attack_queued := false
var next_spell_queued := false;

var enemies_hit = []

#--------# Misc. Info #--------# 

var health = 100
var max_health = 100

#--------# MCE Variables #--------# 
var is_slammed := false


signal spell_casted(spell_name: String)
signal combo_finished  # emitted when a full melee combo completes
signal jump_attack_finished  # emitted when a jump attack is done


func _ready():
	status_effects.connect("tint_changed", Callable(self, "_on_status_tint_changed"))
	add_to_group("player")
	
	attack_manager.shapes = attack_shapes
	attack_manager.offsets = hitbox_offsets

func connect_hud(passedHud: CanvasLayer):
	hud = passedHud
	# Update HUD initially
	health_manager.connect("player_died", Callable(self, "_on_player_died"))
	health_manager.connect("health_changed", Callable(self, "_on_health_changed"))
	# Connect health signals
	health_manager.connect("health_changed", Callable(hud, "update_health"))
	mana_manager.connect("mana_changed", Callable(hud, "update_mana"))
	hud.update_health(health_manager.current_health, health_manager.max_health)
	hud.update_mana(mana_manager.current_mana, mana_manager.max_mana)
	spell_caster.connect("active_spell_changed", func(spells, slot):
		hud.update_spell_icons(spells, slot)
	)
	spell_caster.connect("spell_cooldowns_updated", func(cooldowns):
		hud.update_spell_cooldowns(cooldowns, spell_caster.equipped_spells)
	)
	# Initialize once at start
	hud.update_spell_icons(spell_caster.equipped_spells, spell_caster.active_slot)

func set_stats(data: Dictionary):
	pass
	#charName = data.get("name", "Hero")
	#health = data.get("health", 100)
	#max_health = data.get("max_health", 100)
	#level = data.get("level", 1)
	#xp = data.get("xp", 0)

func reset_state():
	is_attacking = false;
	is_jumping = false;
	force_idle = false;
	special_anim_playing = false;
	attack_manager.end_attack()
	combo_step = 0

func trigger_invuln(duration : float = 1.5):
	 # Apply brief invulnerability frames
	var inv := InvulnerableEffect.new()
	inv.effect_type = &"invulnerable"
	inv.duration = duration  
	inv.stacking_mode = StatusEffect.STACK_REFRESH
	status_effects.apply_effect(inv)

func is_player_invulnerable():
	return status_effects.is_invulnerable()

func take_damage(amount: float, knockback: Vector2 = Vector2.ZERO):
	# Skip if already invulnerable
	if status_effects and status_effects.is_invulnerable():
		return
	if (health_manager.current_health - amount < 0):
		health_manager.take_damage(amount)
		return
	

	health_manager.take_damage(amount)
	reset_state()
	trigger_invuln(2)
	lock_movement(true)
	velocity = Vector2.ZERO
	# Apply knockback (scaled by facing)
	apply_external_force(knockback)
	if $SpellCaster.is_casting:
		$SpellCaster.cancel_cast()
	# Play hurt animation if available
	#if anim.has_animation("hurt"):
	anim.play("hurt")
	await anim.animation_finished
	lock_movement(false)
	
func _on_player_died():
	lock_movement(true)
	trigger_invuln(100)
	# Stop any current actions
	reset_state()
	anim.play("die")

	# Wait until the die animation is done
	await anim.animation_finished

	# Optional: brief delay to let the animation settle
	#await get_tree().create_timer(0.5).timeout

	# Show Game Over screen
	var game_over_screen = get_tree().root.get_node("GameWorld/GameOverScreen")
	if game_over_screen:
		game_over_screen.show_game_over()
	else:
		print("⚠️ GameOverScreen not found in scene tree.")

func _on_health_changed(current, max):
	pass
	#print("Health changed:", current, "/", max)
	# Later: update HUD here


func lock_movement(state: bool):
	movement_locked = state

func apply_external_force(force: Vector2) -> void:
	external_forces += force

func check_input():
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_jump = Input.is_action_just_pressed("ui_accept");
	var input_cast = Input.is_action_just_pressed("spell_cast")
	var input_attack = Input.is_action_just_pressed("attack")
	var input_dodge = Input.is_action_just_pressed("dodge")
	if input_x != 0 or input_jump or input_cast or input_attack or input_dodge:
		return true;
	return false

func _physics_process(delta):
	if check_input():
		special_anim_playing = false;
	if special_anim_playing:
		velocity = Vector2.ZERO
		return
	
	# Apply gravity
	if not is_on_floor() and not movement_locked:
		if is_slammed:
			velocity.x = 0
		else:
			# Base gravity
			velocity.y += gravity * delta
			if is_attacking:
				velocity.x = 0
				velocity.y = 10
			# ✅ Stronger gravity when rising slowly (snaps the peak)
			if velocity.y < 0 and abs(velocity.y) < 100:
				velocity.y += gravity * peak_gravity_multiplier * delta
	else:
		velocity.y = 0
		jumpsLeft = maxJumps
		is_jumping = false
		jump_time = 0.0

	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if(movement_locked):
		input_x = 0
	# Block inputs if stunned (optional)
	if status_effects.is_stunned() or movement_locked:
		input_x = 0.0

	var effective_speed = speed * status_effects.get_move_speed_multiplier()

	if is_dodging:
		velocity = dodge_velocity
	elif not is_attacking:
		if is_on_floor():
			velocity.x = input_x * effective_speed
		else:
			if input_x != 0:
				velocity.x = input_x * effective_speed
	else:
		if is_on_floor():
			velocity.x = 0
	
	#✅ Apply external forces
	velocity += external_forces

	# ✅ Decay external forces gradually (drag effect)
	external_forces = external_forces.move_toward(Vector2.ZERO, 800 * delta)
	# Apply external forces (from suction, knockback, etc.)
	#velocity += external_forces
	external_forces = Vector2.ZERO  # reset after applying
	
	if(movement_locked):
		move_and_slide()
		return
	
	# Jump start
	if Input.is_action_just_pressed("ui_accept") and jumpsLeft > 0:
		if is_jump_attacking:
			finish_jump_attack()
		if is_attacking:
			reset_attack_state()
			
		if(jumpsLeft < maxJumps):
			var player_pos = global_position  # this node is the player
			var jump_effect = magic_circle_scene.instantiate()
			
			jump_effect.set_jump_pos(player_pos + Vector2(0, 30))  # small offset below feet
			# Add the effect to the world (not as a child of the player)
			get_parent().add_child(jump_effect)
			
			# Position it exactly where the player was when jump pressed
			jump_effect.play_jump_cast()

		jumpsLeft -= 1
		
		# ✅ preserve horizontal momentum (dodge or normal movement)
		# do NOT overwrite velocity.x here
		velocity.y = jump_velocity
		
		# ✅ if dodging, cancel the dodge but keep its horizontal velocity
		if is_dodging:
			is_dodging = false
			# dodge_velocity.x is already in velocity.x, so we leave it

		is_jumping = true
		jump_time = 0.0
		anim.play("jump")

	# Jump sustain (hold button)
	if is_jumping and Input.is_action_pressed("ui_accept"):
		jump_time += delta
		if jump_time < max_jump_time:
			velocity.y += sustain_boost * delta   # small upward boost
		else:
			is_jumping = false

	# Cut jump short if button released
	if is_jumping and Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= jump_dampening
		is_jumping = false

	if force_idle:
		force_idle = true;
		#anim.play("idle")
		attack_unlock_timer -= delta
		if attack_unlock_timer <= 0.0:
			force_idle = false
	
	if Input.is_action_just_pressed("spell_cast"):
		if is_jump_attacking or is_dodging:
			return;
			
		if $SpellCaster.equipped_spells[$SpellCaster.active_slot] is not ComboSpell:
			if $SpellCaster.equipped_spells[$SpellCaster.active_slot] is IncantationSpell:
				deactivate_attack_hitbox()
				velocity = Vector2.ZERO
				is_attacking = false
				combo_step = 0
			$SpellCaster.cast_spell()
			return;
		else:
			if velocity.y < 0:
				return;
		if is_attacking:
			# Player pressed spell mid-combo → queue next step AND make it magic
			next_attack_queued = true
			next_spell_queued = true
			if $SpellCaster.active_combo_spell == null:
				await $SpellCaster.cast_spell()
		else:
			# Player is idle → prepare spell and start combo
			await $SpellCaster.cast_spell()
			start_attack()

	elif Input.is_action_just_pressed("attack"):
		if is_jump_attacking or is_dodging:
			return;
		if(anim.animation == "idle"):
			await get_tree().physics_frame
			if force_idle:
				return  # ⛔ block early replays before idle settles
				
		if $SpellCaster.active_combo_spell:
			$SpellCaster.active_combo_spell = null;
			next_spell_queued = false;
		if velocity.y < 0 and not is_attacking and not is_jump_attacking:	
			# Do a jump attack
			start_jump_attack()
			
		elif is_attacking:
			# Queue next ground combo
			next_attack_queued = true
			
		elif not is_attacking:
			# Start ground combo
			start_attack()
	elif Input.is_action_just_pressed("dodge"):
		if is_attacking:
			reset_attack_state()
		if is_jump_attacking:
			is_jump_attacking = false
		
		dodge_caster.try_dodge(self)
			
	
	move_and_slide()
	if not is_attacking and not is_jump_attacking:
		update_animation(input_x)

func update_animation(input_x: float):
	var current_anim = anim.animation
	#var spell_caster = $SpellCaster
	
	if anim.animation == "hurt" and anim.is_playing():
		return
	if is_attacking or is_jump_attacking or is_dodging:
		return
	elif not is_on_floor():
		if velocity.y < 0:
			if current_anim == "jump":
				return
			anim.play("jump")
		elif current_anim != "fall":
			anim.play("fall")
	elif input_x != 0:
		anim.flip_h = input_x < 0
		anim.play("run")
	else:
		anim.play("idle")

# -------- GROUND COMBO LOGIC --------

func start_attack():
	if force_idle:
		return
	
	is_attacking = true
	combo_step += 1
	if combo_step > 4:
		combo_step = 1
	
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# ✅ If airborne, allow direction flip based on opposite input
	if not is_on_floor() and input_x != 0:
		# If input is opposite to current facing direction, flip
		if (anim.flip_h and input_x > 0) or (not anim.flip_h and input_x < 0):
			anim.flip_h = not anim.flip_h  # flip facing direction

	#var spell_caster = $SpellCaster
	if spell_caster.active_combo_spell:
		anim.play("explosion_combo%d" % combo_step)
		anim.frame = 0
	else:
		attack_manager.begin_attack(combo_step, "ground")
		anim.play("attack%d" % combo_step)
		anim.frame = 0


func _set_attack_hitbox(step: int) -> void:
	# Assign a different shape resource for this attack
	attack_shape.shape = attack_shapes[step - 1]
	
	# Update the offset based on facing direction & attack step
	var offset = hitbox_offsets[step - 1]
	attack_area.position = offset if not anim.flip_h else -offset

func reset_attack_state():
	deactivate_attack_hitbox()
	is_attacking = false
	combo_step = 0
	spell_caster.active_combo_spell = null

func finish_attack():
	if next_attack_queued:
		
		if next_spell_queued:
			next_spell_queued = false
			
		next_attack_queued = false
		start_attack()
		
	else:
		# Flag that we manually forced idle
		reset_attack_state()
		force_idle = true
		attack_unlock_timer = 0.2  # ~3 frames at 60fps
		

# -------- JUMP ATTACK LOGIC --------

func start_jump_attack():
	is_jump_attacking = true
	attack_manager.begin_attack(5, "jump")  # 5th slot = jump attack
	anim.play("jump_attack")


func finish_jump_attack() -> void:
	is_jump_attacking = false
	deactivate_attack_hitbox()
	# Return to falling state after spin
	anim.play("fall")


func activate_attack_hitbox():
	attack_area.monitoring = true

func deactivate_attack_hitbox():
	attack_area.monitoring = false

func enter_dodge(invuln_time: float, dodge_timer: float):
	trigger_invuln(invuln_time)
	is_dodging = true
	anim.play("dodge")

	# if dodge not interrupted, clear after timer
	get_tree().create_timer(dodge_timer).timeout.connect(func():
		if is_dodging:
			exit_dodge()
	)


func exit_dodge():
	is_dodging = false
	dodge_velocity = Vector2.ZERO
	anim.play("idle")

func apply_dodge_impulse(impulse: Vector2):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# ✅ If airborne, allow direction flip based on opposite input
	if not is_on_floor() and input_x != 0:
		# If input is opposite to current facing direction, flip
		if (anim.flip_h and input_x > 0) or (not anim.flip_h and input_x < 0):
			anim.flip_h = not anim.flip_h  # flip facing direction

	# Apply facing direction
	if anim.flip_h:
		impulse.x = -impulse.x

	velocity.x = impulse.x
	dodge_velocity = impulse

func _on_status_tint_changed(color: Color, opacity: float):
	anim.modulate = Color(color.r, color.g, color.b, opacity)

#-----------#MID-COMBAT EVENT LOGIC#-----------#
	
func capture_by_chaos_zone(zone: Node2D, damage: int):
	# Hide only the sprite, not the whole player node
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.visible = false

	# Freeze input/movement
	lock_movement(true)
	velocity = Vector2.ZERO
	is_slammed = true;

	# Teleport above the arena relative to zone
	global_position = zone.global_position + Vector2(0, -300)

	# Unlock movement
	lock_movement(false)


func do_chaos_slam(zone: Node2D, damage: int):
	await get_tree().physics_frame  # ← This is probably what's missing
	await get_tree().create_timer(2.0).timeout
	# Reappear for the slam
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.visible = true

	# Slam downward with force
	velocity = Vector2(0, 5500)


	# Apply damage after impact
	take_damage(damage)
	is_slammed = false;

func play_special_animation(name: String):
	if name == "resist":
		anim.play("resist")  # 👈 make sure you have a "resist" animation
		special_anim_playing = true;


func _on_attack_area_body_entered(body: Node2D) -> void:
	if (is_attacking or is_jump_attacking) and body.has_method("take_damage") and not enemies_hit.has(body):
		body.take_damage(10) # Jump attack can deal extra damage
		enemies_hit.append(body)
		

func _on_animated_sprite_2d_frame_changed():
	var current_anim = anim.animation
	var frame = anim.frame
	var facing_dir = -1 if anim.flip_h else 1

	match current_anim:
		"attack1":
			match frame:
				0, 1: attack_manager.activate_hitbox()
				3:    if (Input.get_action_strength("ui_left") or Input.get_action_strength("ui_right")) and not next_attack_queued: finish_attack()
				4:    finish_attack()
				_:    attack_manager.deactivate_hitbox()

		"attack2":
			match frame:
				1: attack_manager.activate_hitbox()
				3: attack_manager.deactivate_hitbox()
				4: finish_attack()

		"attack3":
			match frame:
				1: attack_manager.activate_hitbox()
				3: 
					attack_manager.deactivate_hitbox()
					if (Input.get_action_strength("ui_left") or Input.get_action_strength("ui_right")) and not next_attack_queued:
						finish_attack()
				4: finish_attack()

		"attack4":
			match frame:
				2: emit_signal("combo_finished")
				3: attack_manager.activate_hitbox()
				5: attack_manager.deactivate_hitbox()
				6: finish_attack()

		"jump_attack":
			if is_on_floor():
				finish_jump_attack()
			match frame:
				0, 1, 2: attack_manager.activate_hitbox(); emit_signal("jump_attack_finished")
					
				15:
					attack_manager.deactivate_hitbox()
					finish_jump_attack()
		## MAGIC COMBO
		"explosion_combo1":
			match frame:
				1:
					#var spell_caster = $SpellCaster
					spell_caster.trigger_combo_spell_step(combo_step, self, facing_dir)
				6:
					finish_attack()
		"explosion_combo2":
			match frame:
				1:
					#var spell_caster = $SpellCaster
					spell_caster.trigger_combo_spell_step(combo_step, self, facing_dir)
				5:
					finish_attack()
		"explosion_combo3":
			match frame:
				1:
					#var spell_caster = $SpellCaster
					spell_caster.trigger_combo_spell_step(combo_step, self, facing_dir)
				3:
					finish_attack()
		"explosion_combo4":
			match frame:
				1:
					#var spell_caster = $SpellCaster
					spell_caster.trigger_combo_spell_step(combo_step, self, facing_dir)
				3:
					finish_attack()


#
#func _on_attack_area_area_entered(body: Area2D) -> void:
	#var parentBody = body.get_parent()
	#if (is_attacking or is_jump_attacking) and parentBody.has_method("take_damage") and not enemies_hit.has(body):
		#parentBody.take_damage(10) # Jump attack can deal extra damage
		#enemies_hit.append(body)
		#mana_manager.restore_mana_on_hit();

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var pause_menu = get_tree().root.get_node("GameWorld/PauseMenu")
		if pause_menu:
			pause_menu.toggle_pause()
