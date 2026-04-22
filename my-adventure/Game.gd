extends Node

var game_world_scene :PackedScene= preload("res://scenes/GameWorld.tscn")
var game_world: Node = null
var current_level_path: String = ""

# Called from MainMenu when starting or loading a game
func start_new_game():
	GameStateManager.reset_state()
	await TransitionManager.fade_in(0.5)
	get_tree().change_scene_to_file("res://scenes/MapScreen.tscn")
	await TransitionManager.fade_out(0.5)

func return_to_menu():
	print("🔵 Returning to main menu...")
	await TransitionManager.fade_in(0.5)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	await TransitionManager.fade_out(0.5)

func quit_game():
	print("🔴 Quitting game...")
	get_tree().quit()

# Called from MapScreen to actually start a level
func load_level(level_path: String) -> void:
	await TransitionManager.fade_in(0.5)
	print("🚀 Loading level:", level_path)
	current_level_path = level_path
	# Replace current scene with persistent GameWorld
	get_tree().change_scene_to_packed(game_world_scene)

	# ✅ Wait for the scene change to complete
	await get_tree().process_frame
	await get_tree().process_frame

	# Grab the newly loaded GameWorld
	game_world = get_tree().current_scene
	await get_tree().process_frame
	if game_world and game_world.has_method("load_level"):
		game_world.load_level(level_path)
		await TransitionManager.fade_out(0.5)
	else:
		push_warning("⚠️ GameWorld scene missing or has no load_level()!")

func restart_level():
	game_world.queue_free()
	game_world = null
	load_level(current_level_path)
