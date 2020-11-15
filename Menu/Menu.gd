extends Node2D


func _ready():
	VisualServer.set_default_clear_color(Color("#70d3e0"))

func _on_Start_pressed():
	get_tree().change_scene(Utils.get_scene(1))
