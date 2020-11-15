extends SpellProjectile
class_name EMPProjectile

var stopped_enemies = []
var triggered = false
var initialized = false

func initialize(newDirection: Vector2, target: Vector2, intitialPos: Vector2, newSpell: Spell) -> void:
	global_position = target
	spell = newSpell
	aoeCollider.shape.radius = spell.aoe
	initialized = true

func _physics_process(delta):
	if !triggered and initialized:
		triggered = true
		stopped_enemies = enemyDetectionArea.get_overlapping_areas()
		for enemy in stopped_enemies:
			pass

func _on_EMPTimer_timeout():
	queue_free()


func _on_EnemyDetectionArea_area_entered(area):
	pass # Replace with function body.
