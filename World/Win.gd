extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color("#0b9e24"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Restart_pressed():
	Deck.reset()
	get_tree().change_scene(Utils.get_scene(Utils.level))


func _on_Menu_pressed():
	Deck.reset()
	get_tree().change_scene("res://Menu/Menu.tscn")
