extends Node2D

var meteor_swarm = preload("res://bosses/celestial_primate/Attacks/MeteorSwarm.gd").new()
var meteor_scene = preload("res://bosses/celestial_primate/Attacks/Meteor.tscn")

func _ready():
	meteor_swarm.meteor_scene = meteor_scene
	meteor_swarm.count = 5

	# Simulate boss/player context
	var boss := self
	var player := get_parent().get_node("Player")
	
	await get_tree().create_timer(1.0).timeout  # Delay to observe
	meteor_swarm.execute(self, player)
