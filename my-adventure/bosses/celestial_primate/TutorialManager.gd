extends CanvasLayer
class_name TutorialManager

signal tutorial_finished
signal tutorial_aborted

@export var tutorial_display_path: NodePath
@onready var tutorial_display: AnimatedSprite2D = get_node(tutorial_display_path)
@onready var overlay: Control = $Overlay

var player: Node2D
var boss: Node2D
var pause_menu: CanvasLayer
var active := false
var current_stage := ""
var combo_complete := false
var jump_attack_complete := false

func start_tutorial(p_player: Node2D, p_boss: Node2D, p_pause_menu: CanvasLayer):
	player = p_player
	boss = p_boss
	pause_menu = p_pause_menu
	active = true
	overlay.visible = true
	overlay.modulate.a = 0

	# Connect boss signal for immediate cancellation
	if boss and not boss.is_connected("damaged", Callable(self, "_on_boss_damaged")):
		boss.connect("damaged", Callable(self, "_on_boss_damaged"))

	# Connect player signals for combo or spell progress
	if player and not player.is_connected("combo_finished", Callable(self, "_on_combo_finished")):
		player.connect("combo_finished", Callable(self, "_on_combo_finished"))
	if player and not player.is_connected("jump_attack_finished", Callable(self, "_on_jump_attack_finished")):
		player.connect("jump_attack_finished", Callable(self, "_on_jump_attack_finished"))
	if player and not player.is_connected("spell_casted", Callable(self, "_on_spell_casted")):
		player.connect("spell_casted", Callable(self, "_on_spell_casted"))
		
	if pause_menu and not pause_menu.is_connected("quit", Callable(self, "_on_quit")):
		pause_menu.connect("quit", Callable(self, "_on_quit"))

	print("🎓 Starting tutorial...")
	await _run_movement_stage()
	await _run_attack_stage()
	await _run_spell_stage()

	if active:
		print("📖 Tutorial complete!")
		tutorial_display.play("finish")
		await get_tree().create_timer(2.0).timeout
		_fade_out()
		emit_signal("tutorial_finished")
		queue_free()

# --------------------------
#   STAGE 1: MOVEMENT
# --------------------------
func _run_movement_stage():
	current_stage = "movement"
	await _fade_transition("movement")
	tutorial_display.play("movement")

	var moved_left = false
	var moved_right = false
	var jumped = false
	var double_jumped = false
	var dodged = false

	while active and not (moved_left and moved_right and jumped and double_jumped and dodged):
		if Input.is_action_just_pressed("ui_left"):
			moved_left = true
		if Input.is_action_just_pressed("ui_right"):
			moved_right = true
		if Input.is_action_just_pressed("ui_accept"):
			if not jumped:
				jumped = true
			elif jumped and not double_jumped:
				double_jumped = true
		if Input.is_action_just_pressed("dodge"):
			dodged = true
		await get_tree().process_frame

	await _fade_transition("attack")


# --------------------------
#   STAGE 2: ATTACKING
# --------------------------
func _run_attack_stage():
	current_stage = "attack"
	tutorial_display.play("attack")
	combo_complete = false

	while active:
		if combo_complete and jump_attack_complete:
			break
		await get_tree().process_frame

	await _fade_transition("spellcast")


# --------------------------
#   STAGE 3: SPELLCASTING
# --------------------------
var spell_swapped := {0: false, 1: false, 2: false}
var spell_casted := {0: false, 1: false, 2: false}
var one_swapped = false;
var one_casted = false;

func _run_spell_stage():
	current_stage = "spellcast"
	tutorial_display.play("spellcast")

	while active:
		if one_swapped and one_casted:
			break
		_all_spells_done()
		if Input.is_action_just_pressed("spell_slot_1"):
			spell_swapped[0] = true
		if Input.is_action_just_pressed("spell_slot_2"):
			spell_swapped[1] = true
		if Input.is_action_just_pressed("spell_slot_3"):
			spell_swapped[2] = true
		await get_tree().process_frame

	await _fade_transition("finish")

func _all_spells_done() -> void:
	for i in range(3):
		if (spell_swapped[i]):
			one_swapped = true
		if(spell_casted[i]):
			one_casted = true


# --------------------------
#   SIGNAL CALLBACKS
# --------------------------
func _on_boss_damaged(amount):
	if not active:
		return
	print("⚠️ Tutorial aborted — boss took damage!")
	active = false
	_fade_out()
	emit_signal("tutorial_aborted")
	queue_free()
	
func _on_quit():
	if not active:
		return
	print("⚠️ Tutorial aborted — player quit!")
	active = false
	queue_free()

func _on_combo_finished():
	combo_complete = true

func _on_jump_attack_finished():
	jump_attack_complete = true

func _on_spell_casted(spell_name: String):
	var player_spellcaster = player.get_node_or_null("SpellCaster")
	if player_spellcaster:
		var slot = player_spellcaster.active_slot
		spell_casted[slot] = true


# --------------------------
#   FADE TRANSITION
# --------------------------
func _fade_transition(next_anim: String):
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 0.75)
	await tween.finished
	tutorial_display.play(next_anim)
	tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.75)
	await tween.finished

func _fade_out():
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.75)
	await tween.finished
