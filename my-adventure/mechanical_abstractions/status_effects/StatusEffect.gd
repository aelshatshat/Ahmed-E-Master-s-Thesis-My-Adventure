extends Resource
class_name StatusEffect

# Stacking policy
const STACK_REFRESH := 0
const STACK_STACK := 1
const STACK_IGNORE := 2

@export var effect_type: StringName = &""
@export var duration: float = 1.0
@export var stacking_mode: int = STACK_REFRESH
@export var max_stacks: int = 1

func clone() -> StatusEffect:
	var c := duplicate()
	return c
