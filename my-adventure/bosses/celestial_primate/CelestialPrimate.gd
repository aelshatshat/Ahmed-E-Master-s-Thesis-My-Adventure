extends "res://Boss.gd"
class_name CelestialPrimate

@export var lightning_bolt: LightningBolt
@export var meteor_swarm: MeteorSwarm
@export var fire_column: FireColumnAttack
@export var cold_shock: ColdShock
@export var chaos_crush: ChaosCrush   # Mid-Combat Event

@export var attack_cooldown: Array[float] = [2.0, 1.0, 0.7, 0.5]
#@export var attack_cooldown: Array[float] = [3.0, 3.0, 3.0, 3.0]
@export var attack_cooldown_min: float = 1.5
@export var movement_patterns: Array[Resource] = []

# 🔥 New: distance threshold for movement
@export var movement_range: float = 50.0  

@export var opening_cutscene_scene: PackedScene
@export var ending_cutscene_scene: PackedScene
@export var boss_id: String = "celestial_primate"

@export var phase_change_effect_scene: PackedScene = preload("res://PhaseChangeBurst.tscn")

@onready var attack_timer: Timer = $AttackTimer
@onready var movement_manager: MovementManager = $MovementManager

var cutscene_playing := false

var rng := RandomNumberGenerator.new()
var player_ref: Node2D = null

var triggerChaosCrush : bool = false

var anchors: Array[Node2D] = []

var hasAttacked = false;
var lastAttack : AttackPattern = null;
var hand_swapped := false
var is_dead := false

signal damaged(amount)

func _ready() -> void:
	if Engine.has_singleton("GameStateManager") and GameStateManager.is_boss_defeated(boss_id):
		queue_free()
		return
	
	super._ready()
	rng.randomize()
	
	var tempAnchors = get_tree().get_nodes_in_group("boss_anchor")
	for node in tempAnchors:
		if node is Node2D:
			anchors.append(node)
	
	attack_timer.wait_time = attack_cooldown[0]
	attack_timer.timeout.connect(_choose_action)
	attack_timer.stop() # boss waits until cutscene ends	
	
	phase_changed.connect(_on_phase_changed)
	add_to_group("enemy")
	anim.play("idle")

func set_player(player: Node2D) -> void:
	player_ref = player

# --- Cutscene Signals ---
func on_cutscene_started(name: String) -> void:
	if name == "CelestialPrimateIntro":
		cutscene_playing = true
		if attack_timer:
			attack_timer.stop()
		print("🕐 Celestial Primate waiting for cutscene to end...")

func on_cutscene_ended(name: String) -> void:
	if name == "CelestialPrimateIntro":
		cutscene_playing = false
		print("🎬 Cutscene ended — Celestial Primate awakens!")
		
		var pause_menu :CanvasLayer = get_parent().get_parent().get_parent().get_node_or_null("PauseMenu")

		# Launch tutorial before starting fight
		var tutorial_scene := preload("res://bosses/celestial_primate/TutorialManager.tscn")
		var tutorial := tutorial_scene.instantiate()
		get_tree().root.add_child(tutorial)
		tutorial.start_tutorial(player_ref, self, pause_menu)
		# When the tutorial finishes or is aborted, begin the fight
		tutorial.tutorial_finished.connect(func():
			print("✅ Tutorial complete! Starting boss fight.")
			attack_timer.start()
			anim.play("idle"))

		tutorial.tutorial_aborted.connect(func():
			print("⚠️ Tutorial aborted early. Starting boss fight anyway.")
			attack_timer.start()
			anim.play("idle"))

# --- Core AI Loop ---
func _choose_action() -> void:
	if is_dead or not is_inside_tree():
		return
	if not player_ref:
		return

	var dist = abs(global_position.x - player_ref.global_position.x)
	
	if triggerChaosCrush:
		attack_timer.stop()
		await execute_chaos_crush()
		triggerChaosCrush = false
		anim.play("idle")
		attack_timer.start()
		return
	
	if hasAttacked:
		if dist <= movement_range and rng.randf() < 0.8:
			hasAttacked = false
			await perform_movement(player_ref)
		else:
			await perform_attack(player_ref)
	else:
		hasAttacked = true
		await perform_attack(player_ref)

	anim.play("idle")
	if is_dead or not is_inside_tree():
		return


# --- Attack Selection ---
func perform_attack(player: Node2D) -> void:
	if is_dead or not is_inside_tree():
		return
	var attack: AttackPattern = null
	match current_phase:
		0:
			attack = lightning_bolt
		1:
			while attack == lastAttack:
				attack = [lightning_bolt, meteor_swarm, cold_shock].pick_random()
		2:
			while attack == lastAttack:
				attack = [meteor_swarm, fire_column, cold_shock].pick_random()
		3:
			while attack == lastAttack:
				attack = [lightning_bolt, meteor_swarm, fire_column, cold_shock].pick_random()

	lastAttack = attack

	if attack:
		if attack == cold_shock:
			await execute_attack(attack, "dual_point", 4, 0.5, player)
			anim.play("dual_point_return")
			await anim.animation_finished
		elif attack == meteor_swarm:
			await execute_attack(attack, "right_raise", 6, 0.2, player)
			anim.play("right_raise_return")
			await anim.animation_finished
		elif attack == lightning_bolt:
			if player.global_position < self.global_position:
				await execute_attack(attack, "left_point", 5, 0.3, player)
				await get_tree().create_timer(1).timeout
				if(hand_swapped):
					anim.play("right_point_return")
				else:
					anim.play("left_point_return")
				await anim.animation_finished
			else:
				await execute_attack(attack, "right_point", 5, 0.3, player)
				await get_tree().create_timer(1).timeout
				if(hand_swapped):
					anim.play("left_point_return")
				else:
					anim.play("right_point_return")
				await anim.animation_finished
		elif attack == fire_column:
			await execute_attack(attack, "dual_hand_raise", 1, 0.2, player)
			await get_tree().create_timer(1).timeout
			anim.play("dual_hand_return")
			await anim.animation_finished
		else:
			await attack.execute(self, player)

	# ✅ Attack fully finished — now restart cooldown
	attack_timer.start()
	hand_swapped = false
	if is_dead or not is_inside_tree():
		return

func swap_hands(hand : String):
	if hand == "right":
		anim.play("left_point_return")
		await anim.animation_finished
		anim.play("right_point")
		await anim.animation_finished
	if hand == "left":
		anim.play("right_point_return")
		await anim.animation_finished
		anim.play("left_point")
		await anim.animation_finished
	
	hand_swapped = not hand_swapped

func execute_attack(attack: AttackPattern, animation: String, numRepeats: int, timeBetween: float, player: Node2D) -> void:
	if is_dead or not is_inside_tree():
		return
	anim.play(animation)
	await anim.animation_finished
	for i in range(numRepeats):
		await attack.execute(self, player)
		if i < numRepeats - 1:
			await get_tree().create_timer(timeBetween).timeout
			if is_dead or not is_inside_tree():
				return
	

func execute_chaos_crush():
	if chaos_crush and player_ref:
		await movement_manager.perform_special_movement(self, player_ref)
		
		anim.play("reality_point")
		# ✅ Step 4: Trigger Chaos Crush attack
		await chaos_crush.execute(self, player_ref)
		

func update_attack_speed_based_on_health():
	var health_percentage = self.current_health / self.max_health
	var cooldown = lerp(attack_cooldown_min, attack_cooldown, health_percentage)
	attack_timer.wait_time = cooldown

# --- Movement Selection ---
func perform_movement(player: Node2D) -> void:
	if movement_manager:
		await movement_manager.perform_movement(self, player)
	attack_timer.start()

# --- Phase Event Hook ---
func _on_phase_changed(new_phase: int) -> void:
	print("Celestial Primate phase ", new_phase, " entered!")
	
	if phase_change_effect_scene:
		var effect = phase_change_effect_scene.instantiate()
		effect.global_position = global_position
		match new_phase:
			1:
				effect.modulate = Color(0.8, 0.9, 1.0) # pale blue
			2:
				effect.modulate = Color(0.6, 0.2, 1.0) # chaotic violet
			3:
				effect.modulate = Color(1.0, 0.5, 0.3) # fiery orange
		get_parent().add_child(effect)
	
	if new_phase == 3:
		triggerChaosCrush = true;
		
	attack_timer.wait_time = attack_cooldown[new_phase]

func take_damage(amount: int) -> void:
	super(amount) # call Enemy.take_damage
	emit_signal("damaged", amount)
		
func die():
	if is_dead:
		return
	is_dead = true  # ✅ prevent re-entry
	if attack_timer:
		attack_timer.stop()
	set_process(false)

	# 🎬 Trigger ending cutscene
	var cc = get_tree().get_first_node_in_group("cutscene_controller")
	if cc:
		cc.play_cutscene("CelestialPrimateEnding", {
			"player": player_ref,
			"boss": self
		})
		mark_boss_defeated(boss_id)
	else:
		queue_free()


func play_opening_cutscene():
	if cutscene_playing:
		return
	cutscene_playing = true

	if opening_cutscene_scene:
		var cutscene = opening_cutscene_scene.instantiate()
		get_tree().root.add_child(cutscene)
		cutscene.start_cutscene(self, player_ref)
		await cutscene.cutscene_finished
	else:
		print("⚠️ No opening cutscene assigned for Celestial Primate")

	# After cutscene ends, boss AI starts
	cutscene_playing = false
	#attack_timer.start()
	anim.play("idle")
	
func mark_boss_defeated(id: String):
	var state = GameStateManager
	state.mark_boss_defeated(id)
