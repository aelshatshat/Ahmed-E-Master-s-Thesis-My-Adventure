#extends Node
#
#var current_phase: BossPhase
#var boss: Node2D
#var attack_timer := 0.0
#var cooldown := 1.8
#
#func start_phase(phase: BossPhase, boss_ref: Node2D):
	#current_phase = phase
	#boss = boss_ref
	#attack_timer = 0.0
#
	#if phase.mid_combat_event:
		#var mce = phase.mid_combat_event.new()
		#mce.execute(boss)
		#set_process(false)  # Pause normal AI during event
	#else:
		#print("🧠 Starting phase:", phase.phase_name)
		#set_process(true)
#
#func _process(delta):
	#attack_timer -= delta
	#if attack_timer > 0:
		#return
#
	#if current_phase.attack_patterns.is_empty():
		#return
#
	#var pattern = current_phase.attack_patterns[randi() % current_phase.attack_patterns.size()]
	#pattern.execute(boss, get_tree().get_first_node_in_group("player"))
	#attack_timer = cooldown
