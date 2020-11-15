extends SpellProjectile
class_name EMPProjectile

onready var empTimer = $EMPTimer

var stopped_enemies = []
var triggered = false
var initialized = false
var physics_ran_once = false

onready var empParticle = load("res://Particles/EMPEffect.tscn")

func initialize(newDirection: Vector2, target: Vector2, intitialPos: Vector2, newSpell: Spell) -> void:
	global_position = target
	spell = newSpell
	aoeCollider.shape.radius = spell.aoe
	initialized = true

func _physics_process(delta):
	if !triggered and initialized:
		if !physics_ran_once:
			physics_ran_once = true
			return
		
		triggered = true
		var areas = enemyDetectionArea.get_overlapping_areas()
		for area in areas:
			if area.get_parent() is BaseEnemy and !area.get_parent().frozen:
				stopped_enemies.append(area.get_parent())
				area.get_parent().frozen = true
				
		empTimer.start()
		$Sound.play()
		var newParticle = empParticle.instance()
		add_child(newParticle)
		newParticle.restart()
		

func _on_EMPTimer_timeout():
	for enemy in stopped_enemies:
		if enemy != null and enemy.frozen:
			enemy.frozen = false
	stopped_enemies.clear()
	queue_free()


func _on_EnemyDetectionArea_area_entered(area):
	pass # Replace with function body.
