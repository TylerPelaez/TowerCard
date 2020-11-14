extends Node2D
class_name BaseProjectile

onready var hitbox = $Hitbox

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity * delta

func set_damage(value: int) -> void:
	hitbox.damage = value

func _on_Hitbox_area_entered(area):
	queue_free()

func _on_Hitbox_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
