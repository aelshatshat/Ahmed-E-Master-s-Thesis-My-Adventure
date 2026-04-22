extends Node
class_name CutsceneController

signal cutscene_started(name: String)
signal cutscene_ended(name: String)

var is_playing: bool = false
var player_ref: Node2D
var camera_ref: Camera2D
var hud_ref: CanvasLayer
var boss_bar_ref: CanvasLayer

@export var primate_ending_scene: PackedScene  # e.g., res://scenes/cutscenes/PrimateEndingScene.tscn

func _ready():
	# Optional: group for easy access from bosses or player
	add_to_group("cutscene_controller")

func play_cutscene(name: String, data: Dictionary = {}) -> void:
	if is_playing:
		return
	is_playing = true
	emit_signal("cutscene_started", name)

	var world = get_parent()
	player_ref = world.player if world.get_node_or_null("Player") else null
	camera_ref = world.get_node_or_null("Camera2D")
	hud_ref = world.get_node_or_null("HUD")
	boss_bar_ref = world.get_node_or_null("BossHealthBar")

	# Lock input
	if player_ref and player_ref.has_method("lock_movement"):
		player_ref.lock_movement(true)
	if hud_ref:
		hud_ref.visible = false  # Hide HUD during intro
	if boss_bar_ref:
		boss_bar_ref.visible = false  # Hide HUD during intro

	match name:
		"CelestialPrimateIntro":
			await _play_celestial_primate_intro(data)
		"CelestialPrimateEnding":
			await _play_celestial_primate_ending(data)

	# Restore
	if boss_bar_ref:
		boss_bar_ref.visible = true  # Hide HUD during intro
	if hud_ref:
		hud_ref.visible = true
	if player_ref and player_ref.has_method("lock_movement"):
		player_ref.lock_movement(false)
	is_playing = false
	emit_signal("cutscene_ended", name)


# --- Celestial Primate Intro ---
func _play_celestial_primate_intro(data: Dictionary) -> void:
	var player = data.get("player")
	var primate = data.get("boss")
	var spawn_point = data.get("player_spawn")
	var boss_anchor = data.get("boss_anchor")

	if not (player and primate and spawn_point and boss_anchor):
		push_warning("Missing data for Celestial Primate intro cutscene")
		return

	# 1️⃣ Player teleports in
	player.global_position = spawn_point.global_position
	player.anim.play("level_appear")  # ensure this anim exists
	await player.anim.animation_finished
	player.anim.play("idle")

	# 2️⃣ Primate descends from sky
	primate.global_position = boss_anchor.global_position + Vector2(0, -600)
	primate.visible = true
	var tween := create_tween()
	tween.tween_property(primate, "global_position", boss_anchor.global_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished

	# 3️⃣ Display Boss Intro Text
	await _show_boss_title("THE CELESTIAL PRIMATE")

	# 4️⃣ Return control
	print("Celestial Primate intro complete!")


func _play_celestial_primate_ending(data: Dictionary) -> void:
	var player: Node2D = data.get("player")
	var boss: Node2D = data.get("boss")
	if not player or not boss:
		push_warning("Ending cutscene missing player or boss reference")
		return
	player_ref.trigger_invuln(100)
	player_ref.lock_movement(false)
	# Step 1: Let the player finish falling before locking movement
	await get_tree().create_timer(1).timeout  # adjust if needed for your fall duration
	while not player.is_on_floor():
		await get_tree().process_frame

	# Step 2: Stop both actors
	if player.has_method("lock_movement"):
		player.lock_movement(true)
	if boss.has_node("AttackTimer"):
		boss.get_node("AttackTimer").stop()

	# Step 3: Make the Primate fall down to ground level
	var target_y = 115  # adjust for your ground level
	var tween = create_tween()
	tween.tween_property(boss, "global_position:y", target_y, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished

	# Step 3: Play boss death animation
	if boss.has_node("AnimatedSprite2D"):
		boss.get_node("AnimatedSprite2D").play("die")
	await get_tree().create_timer(2.0).timeout

	# Step 4: Player moves to boss
	# Step 5: Player moves to boss (horizontal movement only)
	if player.has_node("AnimatedSprite2D"):
		var anim_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
		if(player.global_position.x >  boss.global_position.x and not anim_sprite.flip_h):
			anim_sprite.flip_h = true
		elif(player.global_position.x <  boss.global_position.x and anim_sprite.flip_h):
			anim_sprite.flip_h = false
		anim_sprite.play("run")

	var distance_x = abs(player.global_position.x - boss.global_position.x)
	while distance_x > 50:
		var dir = sign(boss.global_position.x - player.global_position.x)
		player.global_position.x += dir * 200 * get_process_delta_time()
		await get_tree().process_frame
		distance_x = abs(player.global_position.x - boss.global_position.x)
	
	# Stop and return to idle
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("idle")
		
		
	await get_tree().create_timer(2.0).timeout
	
	# Step 5: Play external animated cutscene scene
	if primate_ending_scene:
		var scene_instance = primate_ending_scene.instantiate()
		get_tree().root.add_child(scene_instance)
		await scene_instance.tree_exited  # assumes it frees itself when done

	# Step 6: Teleport out sequence
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("level_leave")
	if boss.has_node("AnimatedSprite2D"):
		boss.get_node("AnimatedSprite2D").play("teleport_in")
		var tween2 := boss.create_tween()
		tween2.tween_property(boss, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(1.0).timeout

	# Step 7: End sequence — return to map or cleanup
	get_tree().change_scene_to_file("res://scenes/MapScreen.tscn")


func _show_boss_title(title: String) -> void:
	var world = get_parent()
	var label = get_tree().get_first_node_in_group("boss_label")
	if(label == null):
		label = Label.new()
		label.text = title
		label.modulate.a = 0
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 48)
		label.add_theme_color_override("font_color", Color(1, 1, 1))
		label.add_theme_constant_override("outline_size", 3)
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		get_tree().root.add_child(label)

	var tween := create_tween()
	# Fade in + shadow movement
	tween.parallel().tween_property(label, "modulate:a", 1.0, 1.0)
	tween.parallel().tween_property(label, "shadow_offset_x", 9, 1.0) 

	await tween.finished
	await get_tree().create_timer(1.5).timeout

	tween = create_tween()

	# Fade out + shadow movement
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.parallel().tween_property(label, "shadow_offset_x", 18, 1.0)

	await tween.finished
	label.queue_free()
	
