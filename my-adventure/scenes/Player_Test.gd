extends CharacterBody2D

func _ready():
	add_to_group("player")

func take_damage(amount):
	print("⚡ Player hit! Damage:", amount)
