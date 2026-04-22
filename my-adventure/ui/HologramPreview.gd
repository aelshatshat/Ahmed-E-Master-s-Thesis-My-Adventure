extends Control
class_name HologramPreview

signal travel_pressed(level_name: String)

@export var level_name: String = ""
@export var level_preview_texture: Texture2D
@export var boss_preview_texture: Texture2D
@export var projection_animation: String = "project_in"

@onready var animation_player: AnimationPlayer = $ScreenContainer/AnimationPlayer
@onready var level_preview: TextureRect = $ScreenContainer/LevelPreview
@onready var boss_preview: TextureRect = $ScreenContainer/BossPreview
@onready var travel_button: TextureButton = $ScreenContainer/TravelButton
@onready var level_title: Label = $ScreenContainer/LevelTitle
@onready var boss_title: Label = $ScreenContainer/BossTitle
@onready var projection: Node = $Projection

var boss_locations_to_name: Dictionary = {
	"CelestialPrimatesDomain" : "The Celestial Primate's Domain",
	"MyTower" : "My Tower"
}

var boss_locations_to_boss: Dictionary = {
	"CelestialPrimatesDomain" : "The Celestial Primate",
	"MyTower" : "It's my house"
}

func _ready():
	# Start invisible, fade in via animation
	modulate = Color(1, 1, 1, 1)

	travel_button.pressed.connect(func(): emit_signal("travel_pressed", level_name))
	level_preview.texture = level_preview_texture
	boss_preview.texture = boss_preview_texture
	animation_player.play(projection_animation)
	await animation_player.animation_finished

func update_previews(input_level_preview : Texture2D, input_boss_preview : Texture2D, location_name: String):
	level_preview.texture = input_level_preview
	boss_preview.texture = input_boss_preview
	level_title.text = boss_locations_to_name[location_name]
	boss_title.text = boss_locations_to_boss[location_name]

func play_out_animation():
	if animation_player.has_animation("project_out"):
		animation_player.play("project_out")
		await animation_player.animation_finished
	queue_free()
