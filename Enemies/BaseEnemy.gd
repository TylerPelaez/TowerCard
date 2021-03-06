extends Node2D
class_name BaseEnemy

signal enemy_death
signal enemy_attacked_core(damage)

const EnemyPathFollow = preload("res://Enemies/EnemyPathFollow.tscn")

export var speed: float = 30.0
export var max_health: int = 10
export var damage: float = 10.0

onready var health: int = max_health setget set_health
onready var healthBar: ColorRect = $Control/HealthBar
onready var maxHealthBar: ColorRect = $Control/MaxHealthBar
onready var towerDetectionArea = $TowerDetectionArea
onready var hurtbox = $Hurtbox

onready var blood = load("res://Particles/BlackParticle.tscn")
onready var gib = load("res://Particles/RedParticle.tscn")
onready var boom = load("res://Particles/OrangeParticle.tscn")
onready var spark = load("res://Particles/YellowParticle.tscn")

var speed_multipliers = []
var dying := false

var frozen = false
var enemyPathFollow


func _ready():
	enemyPathFollow = EnemyPathFollow.instance()
	
func initialize(pathFollowParent: Node):
	pathFollowParent.add_child(enemyPathFollow)
	enemyPathFollow.set_offset(0)
	enemyPathFollow.remoteTransform.remote_path = enemyPathFollow.remoteTransform.get_path_to(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dying && !frozen:
		var current_speed = speed
		for multiplier in speed_multipliers:
			current_speed = current_speed * (1 - multiplier.slow_amount)
		enemyPathFollow.set_offset(enemyPathFollow.get_offset() + (current_speed * delta))
#		z_index = floor(enemyPathFollow.get_offset())
	
func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	healthBar.rect_size.x = (float(health) / float(max_health)) * float(maxHealthBar.rect_size.x)
	
	if health <= 0 && !dying:
		dying = true
		
		var newGib = gib.instance()
		add_child(newGib)
		newGib.restart()
		
		var newSpark = spark.instance()
		add_child(newSpark)
		newSpark.restart()
		
		var newBoom = boom.instance()
		add_child(newBoom)
		newBoom.restart()
		
		emit_signal("enemy_death")
		if $AnimationPlayer.has_animation("Die"):
			$AnimationPlayer.play("Die")
		$DieSound.play()
		
func died():
	queue_free()

func _on_Hurtbox_hit(damage):
	var newBleed = blood.instance()
	add_child(newBleed)
	newBleed.restart()
	self.health -= damage
	$HitSound.play()

func _on_VisibilityNotifier2D_screen_exited():
	if dying:
		return
	emit_signal("enemy_attacked_core", damage)
	emit_signal("enemy_death")
	call_deferred("queue_free")

func _on_begin_death():
	towerDetectionArea.monitorable = false
	hurtbox.monitorable = false

# Slow field entered
func _on_Hurtbox_area_entered(area):
	if area.get_parent() is SlowFieldPivot:
		$SlowSound.play()
		speed_multipliers.append(area.get_parent())

#Slow field exited
func _on_Hurtbox_area_exited(area):
	if area.get_parent() is SlowFieldPivot:
		speed_multipliers.erase(area.get_parent())


func get_unit_offset() -> float:
	return enemyPathFollow.unit_offset
