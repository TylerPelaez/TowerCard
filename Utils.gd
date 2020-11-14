extends Node

var DRAW_DEBUG = false
var level = 1

func instance_scene_on_main(scene: PackedScene, position: Vector2) -> Node:
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func is_main_scene(scene: Node) -> bool:
	return scene.name == get_tree().current_scene.name
	
func get_scene(sceneNumber):
	return "res://World/Level" + str(sceneNumber) + ".tscn"
