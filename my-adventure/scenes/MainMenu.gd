extends Control

func _ready():
	$NewGameButton.pressed.connect(_on_new_game_pressed)
	$LoadGameButton.pressed.connect(_on_load_game_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed():
	Game.start_new_game()

func _on_load_game_pressed():
	Game.start_new_game()  # For now, send to map until loading is implemented

func _on_quit_pressed():
	Game.quit_game()
