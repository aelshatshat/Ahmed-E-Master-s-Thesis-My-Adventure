extends CanvasLayer

@onready var restart_button: Button = $VBoxContainer/Restart
@onready var map_button: Button = $VBoxContainer/QuitMap
@onready var quit_button: Button = $VBoxContainer/QuitGame
@onready var label: Label = $Label

func _ready():
	visible = false
	restart_button.pressed.connect(_on_restart_pressed)
	map_button.pressed.connect(_on_map_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_game_over():
	get_tree().paused = true
	visible = true
	#label.modulate = Color(1,1,1,0)
	#var tween := create_tween()
	#tween.tween_property(label, "modulate:a", 1.0, 0.6)

func _on_restart_pressed():
	get_tree().paused = false
	
	hide()  # Hide game over screen after restart
	# Find the GameWorld instance
	Game.restart_level()
	


func _on_map_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MapScreen.tscn")

func _on_quit_pressed():
	get_tree().quit()
