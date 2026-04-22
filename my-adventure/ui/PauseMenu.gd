extends CanvasLayer
class_name PauseMenu

@onready var resume_button: Button = $VBoxContainer/Resume
@onready var quit_to_map_button: Button = $VBoxContainer/QuitMap
@onready var quit_button: Button = $VBoxContainer/QuitGame

signal quit

func _ready():
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	quit_to_map_button.pressed.connect(_on_quit_to_map_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func toggle_pause():
	if get_tree().paused:
		_resume_game()
	else:
		_pause_game()

func _pause_game():
	get_tree().paused = true
	visible = true

func _resume_game():
	get_tree().paused = false
	visible = false

func _on_resume_pressed():
	_resume_game()

func _on_quit_to_map_pressed():
	get_tree().paused = false
	emit_signal("quit")
	#await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/MapScreen.tscn")

func _on_quit_pressed():
	emit_signal("quit")
	get_tree().quit()
	
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#toggle_pause()
