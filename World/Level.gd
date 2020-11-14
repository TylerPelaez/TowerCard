extends Node2D

class_name Level

const BaseEnemyScene: PackedScene = preload("res://Enemies/BasicEnemy.tscn")
onready var enemyPath = $EnemyPath
onready var playerController = $PlayerController
onready var placementArea = $PlacementArea
onready var enemySpawnerTimer = $EnemySpawnerTimer

export var enemies_to_spawn: int = 10

func _ready():
	playerController.set_level_placement_area(placementArea)

func _spawnEnemy(resource: Resource) -> void:
	var instance = resource.instance()
	enemyPath.add_child(instance)
	instance.global_position = enemyPath.global_position


func _on_EnemySpawnerTimer_timeout():
	_spawnEnemy(BaseEnemyScene)
	enemies_to_spawn -= 1
	if enemies_to_spawn >= 0:
		enemySpawnerTimer.start()
