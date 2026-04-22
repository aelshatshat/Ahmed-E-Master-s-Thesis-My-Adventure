extends Node2D
class_name SpellSwapIcon

@export var lifetime: float = 1.0
@export var offset: Vector2 = Vector2(0, -48)
@export var follow_player: bool = true

@onready var bg: AnimatedSprite2D = $Background
@onready var sub: AnimatedSprite2D = $SubIcon

# internal
var _player_ref: Node2D = null
var _pending_spell = null
var _pending_player = null
var _pending_offset: Vector2 = Vector2.ZERO
var _is_fading_out := false

func _ready() -> void:
	# start transparent/small so tween in looks good
	modulate.a = 0.0
	scale = Vector2.ONE * 0.8

	# if setup() was called before node was added, apply it now
	if _pending_spell != null:
		_apply_setup(_pending_spell, _pending_player, _pending_offset)
		_pending_spell = null
		_pending_player = null

func _process(_delta: float) -> void:
	# follow player while alive / until freed
	if follow_player and _player_ref:
		global_position = _player_ref.global_position + offset

# Public API: call after instancing (preferably after add_child)
# spell: a Resource (Spell) or any object with .resource_name / runtime type
# player: Node2D to follow (typically the player node)
# pos_offset: Vector2 offset from player
func setup(spell, player: Node2D, pos_offset: Vector2) -> void:
	# If node isn't in scene tree yet, stash and wait for _ready()
	if not is_inside_tree() or bg == null or sub == null:
		_pending_spell = spell
		_pending_player = player
		_pending_offset = pos_offset if pos_offset != null else offset
		return

	_apply_setup(spell, player, pos_offset)


func _apply_setup(spell, player: Node2D, pos_offset: Vector2) -> void:
	_player_ref = player
	if pos_offset != null:
		offset = pos_offset

	# default visuals (safety)
	if bg and bg.sprite_frames and bg.sprite_frames.get_animation_names().is_empty() == false:
		# choose background animation based on spell type (use your anim names)
		if typeof(spell) == TYPE_OBJECT and (spell is ComboSpell):
			if bg.sprite_frames.has_animation("combo"):
				bg.play("combo")
		elif typeof(spell) == TYPE_OBJECT and (spell is IncantationSpell):
			if bg.sprite_frames.has_animation("incantation"):
				bg.play("incantation")
		elif typeof(spell) == TYPE_OBJECT and (spell is InstantSpell):
			if bg.sprite_frames.has_animation("instant"):
				bg.play("instant")
		else:
			if bg.sprite_frames.has_animation("default"):
				bg.play("default")

	# sub icon: try to play animation named after the spell.resource_name (fallback to "default")
	if sub and sub.sprite_frames:
		var anim_name : String = spell.name.to_lower()
		print(spell.name.to_lower())
		if anim_name != "" and sub.sprite_frames.has_animation(anim_name):
			sub.play(anim_name)
		elif sub.sprite_frames.has_animation("default"):
			sub.play("default")

	# position immediately above player if provided
	if _player_ref:
		global_position = _player_ref.global_position + offset

	# start visual sequence: fade in + slight pop
	var t_in := create_tween()
	t_in.tween_property(self, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t_in.tween_property(self, "scale", Vector2.ONE * 1.05, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# schedule fade out after lifetime
	# use a deferred timer so we don't block ready/process
	_call_later_start_lifetime()


func _call_later_start_lifetime() -> void:
	# use call_deferred to keep things safe in case we're mid-frame
	call_deferred("_start_lifetime_timer")


func _start_lifetime_timer() -> void:
	# if user changed lifetime to 0 or negative, fade out immediately
	if lifetime <= 0:
		_start_fade_out()
		return
	# run async timer
	await get_tree().create_timer(lifetime).timeout
	if not _is_fading_out:
		_start_fade_out()


func _start_fade_out() -> void:
	_is_fading_out = true
	# small pop then fade out
	var t := create_tween()
	t.tween_property(self, "scale", scale * 1.15, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_interval(0.05)
	t.tween_property(self, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_property(self, "scale", Vector2.ONE * 0.85, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.finished.connect(queue_free)
