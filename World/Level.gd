extends Node2D

class_name Level

const BaseEnemyResource: Resource = preload("res://Enemies/BaseEnemy.tscn")
const BasicTowerResource: Resource = preload("res://Towers/BasicTower.tscn")

const NO_PLACEMENT_DISTANCE: float = 5.0

onready var enemyPath = $EnemyPath

func _ready():
	_spawnEnemy(BaseEnemyResource)


func _spawnEnemy(resource: Resource) -> void:
	var instance = resource.instance()
	enemyPath.add_child(instance)
	instance.global_position = enemyPath.global_position

func _spawnTower(tower: Resource, spawnPosition: Vector2) -> void:
	var instance = tower.instance()
	get_tree().current_scene.add_child(instance)
	instance.global_position = spawnPosition

func _on_PlacementArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		print(event.global_position)
		_spawnTower(BasicTowerResource, event.position)
