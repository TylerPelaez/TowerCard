extends Node2D
class_name SpellProjectile

export var speed: float = 10.0

onready var enemyDetectionArea = $EnemyDetectionArea
onready var aoeCollider = $EnemyDetectionArea/AOECollider

onready var boom = load("res://Particles/OrangeParticle.tscn")
onready var spark = load("res://Particles/YellowParticle.tscn")

var exploded = false

var velocity = Vector2.ZERO
var target_position = Vector2.ZERO
var initial_position = Vector2.ZERO

var spell

func _physics_process(delta):
	global_position += velocity * delta	
	if global_position.distance_squared_to(initial_position) >= target_position.distance_squared_to(initial_position):
		trigger_effect()

func initialize(newDirection: Vector2, target: Vector2, intitialPos: Vector2, newSpell: Spell) -> void:
	velocity = newDirection.normalized() * speed
	target_position = target
	initial_position = intitialPos
	spell = newSpell
	rotation = velocity.angle()
	if aoeCollider.shape is CircleShape2D:
		aoeCollider.shape.radius = spell.aoe
	

func trigger_effect() -> void:
	if !exploded:
		var newSpark = spark.instance()
		add_child(newSpark)
		newSpark.restart()
		
		var newBoom = boom.instance()
		add_child(newBoom)
		newBoom.restart()
		
		$ExplodeSound.play()
	exploded = true
	var overlapping = enemyDetectionArea.get_overlapping_areas()
	
	for area in overlapping:
		if area.get_parent() is BaseEnemy:
			area.get_parent().health -= spell.damage
	$Sprite.visible = false
	


func _on_ExplodeSound_finished():
	queue_free()
