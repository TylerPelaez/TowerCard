extends Node2D

func _ready():
	pass

func _on_Hitbox_area_entered(area):
	queue_free()

func _on_Hitbox_body_entered(body):
	queue_free()
