extends Node
class_name DodgeCaster

@export var equipped_dodge_spell: DodgeSpell
var on_cooldown := false

var cooldown_timer: Timer

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_dodge_cooldown_finished"))

func try_dodge(player: Node2D):
	if on_cooldown:
		return
	if equipped_dodge_spell:
		equipped_dodge_spell.perform_dodge(self, player)

func _start_dodge_cooldown():
	on_cooldown = true
	cooldown_timer.start(equipped_dodge_spell.cooldown_time)

func _on_dodge_cooldown_finished():
	on_cooldown = false
