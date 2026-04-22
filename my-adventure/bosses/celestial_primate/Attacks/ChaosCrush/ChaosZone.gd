extends Area2D
class_name ChaosZone

@export var suction_strength: float = 10000.0
@export var suction_radius: float = 10050.0
@export var capture_delay: float = 5.0
@export var damage: int = 50
@export var slam_height: float = -400.0
@export var slam_force: float = 1000.0

@export var min_anim_speed: float = 0.5
@export var max_anim_speed: float = 2.0

@export var safe_zone_width: float = 50.0  # half-width of "middle safe zone"

@export var lotus_seat: PackedScene
@export var yin_yang: PackedScene
@export var suction_scene: PackedScene
var text_scene: PackedScene = preload("res://bosses/celestial_primate/MCEs/MCEText.tscn")

var suction_effect: Node = null

var player_captured := false
var player_ref: Node2D = null
var player_safe := false
var safe_zone_active := false
var chaos_zone_active := false;

var indicator: Node = null
var yinYangDefence: Node = null
var text: Node = null

signal zone_finished


func _ready():
	indicator = lotus_seat.instantiate()
	add_child(indicator)
	indicator.position = Vector2(0, 205)

	# Start with "active" animation but very small
	$AnimatedSprite2D.play("active")
	$AnimatedSprite2D.scale = Vector2(0.1, 0.1)  # tiny starting scale

	# Tween scale up to full size
	var tween := create_tween()
	tween.tween_property(
		$AnimatedSprite2D, "scale",
		Vector2.ONE, 3  # duration can be adjusted
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished

	# Safe zone logic after animation finishes
	if player_ref and abs(player_ref.global_position.x - global_position.x) <= safe_zone_width:
		player_safe = true
		if player_ref.has_method("play_special_animation"):
			player_ref.play_special_animation("resist")
			yinYangDefence = yin_yang.instantiate()
			add_child(yinYangDefence)
			yinYangDefence.global_position = player_ref.global_position
			
			text = text_scene.instantiate()
			get_parent().add_child(text)  # same parent as ChaosZone
			text.show_text("[YinYang Defence]", 2.0, self.global_position + Vector2(-130, -120))

	safe_zone_active = true
	chaos_zone_active = true

	# Wait for capture delay
	await get_tree().create_timer(capture_delay).timeout

	if indicator:
		indicator.queue_free()
		
	if not player_captured:
		$AnimatedSprite2D.play("fade_out")
		await $AnimatedSprite2D.animation_finished
		zone_finished.emit()
		queue_free()


func _physics_process(delta: float) -> void:
	if not chaos_zone_active:
		return

	if not player_ref or player_captured:
		return

	suction_effect = suction_scene.instantiate()
	get_parent().add_child(suction_effect)
	suction_effect.start_suction(global_position, 1.0)
	# If safe zone immunity is active, skip suction
	if player_safe:
		# Check if the player moved (lost immunity)
		if player_ref.anim.animation != "resist":
			print("⚡ Player left safe zone → immunity revoked")
			player_safe = false
			if(text):
				text.reset_colour(Color(0,0,0), Color(1,0,0))
			if(yinYangDefence):
				await yinYangDefence.fade_out()
			_on_InnerCaptureShape_body_entered(player_ref)
		else:
			return
	
	

	var to_center = global_position - player_ref.global_position
	var distance = to_center.length()

	if distance < suction_radius:
		var falloff = clamp(1.0 - (distance / suction_radius), 0.0, 1.0)
		var force = to_center.normalized() * suction_strength * falloff
		if player_ref.has_method("apply_external_force"):
			player_ref.apply_external_force(force * delta)
		$AnimatedSprite2D.speed_scale = lerp(min_anim_speed, max_anim_speed, falloff)
	else:
		$AnimatedSprite2D.speed_scale = min_anim_speed

func _on_InnerCaptureShape_body_entered(body: Node2D):
	if body.is_in_group("player") and not player_captured and chaos_zone_active:
		# If immune, skip capture
		if player_safe:
			print("✅ Player resisted Chaos Zone!")
			return
		player_captured = true
		player_ref = body
		_trigger_capture(body)


func _trigger_capture(body: Node2D):
	$AnimatedSprite2D.play("active")
	await body.capture_by_chaos_zone(self, damage)
	if(indicator):
		indicator.fade_out()
	$AnimatedSprite2D.play("fade_out")
	await $AnimatedSprite2D.animation_finished
	await body.do_chaos_slam(self, damage)
	zone_finished.emit()
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_ref = body
