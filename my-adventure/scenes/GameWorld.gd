extends Node2D

@export var player_scene: PackedScene
@export var hud_scene: PackedScene

@onready var level_container = $LevelContainer
@onready var pause_menu = $PauseMenu
@onready var fade_layer: CanvasLayer = $FadeLayer

var current_level: Node = null
var player: Node2D = null
var player_spawn: Node2D = null
var hud: CanvasLayer = null
var current_level_name: String = ""
var restart : bool = false;

func _ready():
	#load_level("res://scenes/levels/CelestialPrimatesDomain.tscn")
	_setup_camera()
	pause_menu.hide()
	

func load_level(path: String):
	# Free old level
	if current_level:
		current_level.queue_free()

	# Load and instantiate new level
	var level_scene = load(path)
	current_level = level_scene.instantiate()
	level_container.add_child(current_level)
	current_level_name = current_level.name
	setup_level()
	
func setup_level():
	# --- Player setup ---
	player_spawn = current_level.get_node_or_null("PlayerStart")
	if not player:
		player = player_scene.instantiate()
		add_child(player)
	if player_spawn:
		player.global_position = player_spawn.global_position
	else:
		player.global_position = Vector2(100, 100)

	hud = hud_scene.instantiate()
	add_child(hud)
	# Ensure HUD is on top (CanvasLayer > Node2D)
	hud.layer = 1


	player.connect_hud(hud)
	# ✅ Apply per-level camera settings
	_apply_camera_settings(current_level)
	
	match current_level_name:
		"CelestialPrimatesDomain":
			celestial_primate_setup()
		"MyTower":
			hud.visible = false

func celestial_primate_setup():
	# --- Boss setup ---
	var boss = current_level.get_node_or_null("CelestialPrimate")
	if boss:
		boss.set_player(player)
	
	var intro_anchor = current_level.get_node_or_null("ChaosCrushAnchor")
	# Start intro cutscene (if defined for this level)
	var cc = $CutsceneController
	if boss and cc:
		if not restart:
			# 🧠 Hook the boss to cutscene signals
			cc.cutscene_started.connect(func(name): boss.on_cutscene_started(name))
			cc.cutscene_ended.connect(func(name): boss.on_cutscene_ended(name))

		cc.play_cutscene("CelestialPrimateIntro", {
			"player": player,
			"boss": boss,
			"player_spawn": player_spawn,
			"boss_anchor": intro_anchor
		})
	else:
		if boss:
			boss.attack_timer.start()  # No cutscene → start immediately

func _setup_camera():
	$Camera2D.make_current()
	
func _apply_camera_settings(level: Node):
	var camera = $Camera2D
	var settings = level.get_node_or_null("CameraSettings")

	if not settings or not camera:
		return
#
	camera.zoom = settings.zoom
	camera.offset = settings.offset
