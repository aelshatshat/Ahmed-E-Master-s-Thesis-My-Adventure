extends Control

@export var level_paths := {
	"CelestialPrimatesDomain": "res://scenes/levels/CelestialPrimatesDomain.tscn",
	"MyTower": "res://scenes/levels/MyTower.tscn"
}

@export var unlocked_locations: Array[String] = ["CelestialPrimatesDomain", "MyTower"]
@export var completed_locations: Array[String] = []

@onready var locations_container := $Locations
@onready var map_texture := $MapTexture
@onready var hologram_scene := preload("res://ui/HologramPreview.tscn")

var active_hologram: HologramPreview = null

func _ready():
	get_tree().paused = false
	
	for button in locations_container.get_children():
		if button is TextureButton:
			button.pressed.connect(func(): _on_location_selected(button))
			
			var unlocked = button.name in unlocked_locations
			button.disabled = not unlocked
			button.modulate = Color(1, 1, 1, 1 if unlocked else 0.4)
			
			for location in GameStateManager.completed_locations:
				if button.name == location:
					button.disabled = true
					button.modulate = Color(1, 1, 1, 0.4)

	$BackButton.pressed.connect(_on_back_pressed)

func _on_location_selected(button: TextureButton):
	var location_name = button.name
	print("🗺️ Selected:", location_name)

	# Prevent multiple holograms
	if active_hologram:
		await active_hologram.play_out_animation()
		active_hologram = null

	if not level_paths.has(location_name):
		push_warning("No level path for %s" % location_name)
		return

	# Create the holographic projection
	active_hologram = hologram_scene.instantiate()
	add_child(active_hologram)

	# Position above the clicked button
	active_hologram.global_position = button.global_position + Vector2(-285, -400)
	active_hologram.level_name = location_name
	var level_preview_texture = null
	var boss_preview_texture = null
	# Assign preview images (these can be pulled from a data dictionary)
	match location_name:
		"CelestialPrimatesDomain":
			level_preview_texture = preload("res://sprites/hud/menus/map_elements/celestial_primates_domain_preview.png")
			boss_preview_texture = preload("res://sprites/hud/menus/map_elements/celestial_primates_preview.png")
		#"MyTower":
			#active_hologram.level_preview_texture = preload("res://ui/previews/mytower_stage.png")
			#active_hologram.boss_preview_texture = preload("res://ui/previews/mytower_boss.png")
	active_hologram.update_previews(level_preview_texture, boss_preview_texture, location_name)
	active_hologram.travel_pressed.connect(func(_level_name):
		_on_travel_confirmed(_level_name))

func _on_travel_confirmed(location_name: String):
	if not level_paths.has(location_name):
		push_warning("No level path for %s" % location_name)
		return

	# Optional: play out animation before transition
	#if active_hologram:
		#await active_hologram.play_out_animation()

	Game.load_level(level_paths[location_name])

func _on_back_pressed():
	Game.return_to_menu()
