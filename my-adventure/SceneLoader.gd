extends Node

# Load and switch to a new scene
func load_scene(path: String):
	print("[SceneLoader] Loading scene: ", path)

	var new_scene = load(path)
	if not new_scene:
		push_error("[SceneLoader] Failed to load scene: " + path)
		return

	var new_scene_instance = new_scene.instantiate()

	# Replace current scene
	var tree = get_tree()
	var current_scene = tree.current_scene

	if current_scene:
		current_scene.queue_free()

	tree.root.add_child(new_scene_instance)
	tree.current_scene = new_scene_instance

	print("[SceneLoader] Scene loaded successfully.")
