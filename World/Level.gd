extends Node2D

class_name Level

const BaseEnemyResource: Resource = preload("res://Enemies/BaseEnemy.tscn")
onready var enemyPath = $EnemyPath
onready var playerController = $PlayerController
onready var placementArea = $PlacementArea

func _ready():
	_spawnEnemy(BaseEnemyResource)
	playerController.set_level_placement_area(placementArea)

func _spawnEnemy(resource: Resource) -> void:
	var instance = resource.instance()
	enemyPath.add_child(instance)
	instance.global_position = enemyPath.global_position
