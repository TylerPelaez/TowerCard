extends Node

signal wave_finished_spawning
signal wave_finished_enemy_death
signal spawner_enemy_attacked_core(damage)

const enemyConfigNamesToScenes = {"basic": preload("res://Enemies/BasicEnemy.tscn") }


onready var spawnTimer = $SpawnTimer

var enemy_spawn_target
var spawn_configuration := []
var current_wave_configuration := []

var current_wave_total_enemy_count := 0
var current_wave_enemy_death_count := 0

func _ready():
	pass

func initialize(enemySpawnTarget: Node, levelName: String) -> void:
	enemy_spawn_target = enemySpawnTarget
	var file = File.new()
	file.open("res://World/" + levelName + "Config.json", file.READ)
	var text = file.get_as_text()
	var p = JSON.parse(text)
	if typeof(p.result) == TYPE_ARRAY:
		spawn_configuration = p.result
	else:
		print("ERROR. Could not load enemy spawn data")
		
func get_wave_count() -> int:
	return spawn_configuration.size()

func start_wave(wave_number: int) -> void:
	current_wave_configuration = [] + spawn_configuration[wave_number - 1]
	var totalCount: int = 0
	for configToSpawnCount in current_wave_configuration:
		totalCount += configToSpawnCount.values()[0]
	
	current_wave_total_enemy_count = totalCount
	current_wave_enemy_death_count = 0
	spawnTimer.start()

func _spawnEnemy(resource: Resource) -> void:
	var instance = resource.instance()
	enemy_spawn_target.add_child(instance)
	instance.global_position = enemy_spawn_target.global_position
	instance.connect("enemy_death", self, "_onEnemy_death")
	instance.connect("enemy_attacked_core", self, "_onEnemy_attacked_core")

func _on_SpawnTimer_timeout():
	var currentEnemyConfigName = current_wave_configuration[0].keys()[0]
	var currentEnemyPackedScene = enemyConfigNamesToScenes[currentEnemyConfigName]
	_spawnEnemy(currentEnemyPackedScene)
	current_wave_configuration[0][currentEnemyConfigName] -= 1
	if current_wave_configuration[0][currentEnemyConfigName] <= 0:
		current_wave_configuration.pop_front()
	if !current_wave_configuration.empty():
		spawnTimer.start()
	else:
		emit_signal("wave_finished_spawning")
	
func _onEnemy_death():
	current_wave_enemy_death_count += 1
	if current_wave_enemy_death_count == current_wave_total_enemy_count:
		emit_signal("wave_finished_enemy_death")

func _onEnemy_attacked_core(damage: float):
	print("here")
	emit_signal("spawner_enemy_attacked_core", damage)
