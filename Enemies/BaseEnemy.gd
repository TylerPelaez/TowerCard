extends PathFollow2D
class_name BaseEnemy

signal enemy_death
signal enemy_attacked_core(damage)

export var speed: float = 30.0
export var max_health: int = 10
export var damage: float = 10.0

onready var health: int = max_health setget set_health
onready var healthBar: ColorRect = $Control/HealthBar
onready var maxHealthBar: ColorRect = $Control/MaxHealthBar

var dying := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_offset(get_offset() + (speed * delta))
	z_index = floor(get_offset())
	
func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	healthBar.rect_size.x = (float(health) / float(max_health)) * float(maxHealthBar.rect_size.x)
	
	if health <= 0:
		dying = true
		emit_signal("enemy_death")
		queue_free()

func _on_Hurtbox_hit(damage):
	self.health -= damage

func _on_VisibilityNotifier2D_screen_exited():
	if dying:
		return
	emit_signal("enemy_attacked_core", damage)
	emit_signal("enemy_death")
	call_deferred("queue_free")
