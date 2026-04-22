extends Area2D

@export var swap_menu_scene: PackedScene = preload("res://ui/world_objects/spell_swap/SpellSwapMenu.tscn")

var player_in_range := false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		open_swap_menu()

func open_swap_menu():
	var menu := swap_menu_scene.instantiate()
	get_tree().root.add_child(menu)
	menu.open()
