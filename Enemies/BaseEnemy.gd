extends PathFollow2D
class_name BaseEnemy

signal enemy_death

const BASE_SPEED = 30

export var max_health := 10

onready var health: int = max_health setget set_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_offset(get_offset() + (BASE_SPEED * delta))
	
func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("enemy_death")
		queue_free()

func _on_Hurtbox_hit(damage):
	self.health -= damage
