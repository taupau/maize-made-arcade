extends Node

var scene = null
func _ready():
	var root = get_tree().root
	scene = root.get_child(root.get_child_count() - 1)
	
func change_scene(path):
	call_deferred("_change_scene", path)
	
func _change_scene(path):
	scene.free()
	scene = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(scene)
	get_tree().scene = scene
