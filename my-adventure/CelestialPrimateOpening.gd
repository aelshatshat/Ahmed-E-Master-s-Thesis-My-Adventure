extends Node2D
signal cutscene_finished

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var fade_rect: ColorRect = $CanvasLayer/ColorRect
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var cam: Camera2D = $Camera2D

var boss_ref: Node2D
var player_ref: Node2D

func start_cutscene(boss: Node2D, player: Node2D):
	boss_ref = boss
	player_ref = player

	# Freeze both characters
	if player_ref.has_method("lock_movement"):
		player_ref.lock_movement(true)
	if boss_ref.has_method("set_process"):
		boss_ref.set_process(false)

	# Center camera roughly between player and boss
	var mid_pos = (boss_ref.global_position + player_ref.global_position) / 2.0
	global_position = mid_pos
	cam.make_current()

	# Start fade in cinematic animation
	anim_player.play("opening")
	await anim_player.animation_finished

	# Restore player control
	if player_ref.has_method("lock_movement"):
		player_ref.lock_movement(false)
	if boss_ref.has_method("set_process"):
		boss_ref.set_process(true)

	emit_signal("cutscene_finished")
	queue_free()
