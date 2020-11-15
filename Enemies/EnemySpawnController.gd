extends Node

signal wave_finished_spawning
signal wave_finished_enemy_death
signal spawner_enemy_attacked_core(damage)

onready var spawnTimer = $SpawnTimer

var enemy_spawn_target
var enemy_path
var spawn_configuration := []
var current_wave_configuration := []

var current_wave_total_enemy_count := 0
var current_wave_enemy_death_count := 0

func _ready():
	pass

func initialize(enemySpawnTarget: Node, enemyPath: Path2D, levelConfig: int) -> void:
	enemy_spawn_target = enemySpawnTarget
	enemy_path = enemyPath
	print(LevelWaveConfigs.DATA[levelConfig])
	spawn_configuration = []
	for wave in LevelWaveConfigs.DATA[levelConfig]:
		var new_wave = []
		for enemyConfig in wave:
			new_wave.append({enemyConfig.keys()[0]: enemyConfig.values()[0]})
		spawn_configuration.append(new_wave)
	
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
	instance.initialize(enemy_path)
	
	instance.connect("enemy_death", self, "_onEnemy_death")
	instance.connect("enemy_attacked_core", self, "_onEnemy_attacked_core")

func _on_SpawnTimer_timeout():
	var currentEnemyConfigName = current_wave_configuration[0].keys()[0]
	var currentEnemyPackedScene = LevelWaveConfigs.CONFIGS_TO_SCENES[currentEnemyConfigName]
	_spawnEnemy(currentEnemyPackedScene)
	current_wave_configuration[0][currentEnemyConfigName] -= 1
	if current_wave_configuration[0][currentEnemyConfigName] <= 0:
		current_wave_configuration.pop_front()
	if !current_wave_configuration.empty():
		spawnTimer.start()
	else:
		print("EMIT FINISHED SPAWNING")
		emit_signal("wave_finished_spawning")
	
func _onEnemy_death():
	current_wave_enemy_death_count += 1
	if current_wave_enemy_death_count == current_wave_total_enemy_count:
		print("EMIT ENEMIES DEAD")
		emit_signal("wave_finished_enemy_death")

func _onEnemy_attacked_core(damage: float):
	print("EMIT DAMAGE CORE")
	emit_signal("spawner_enemy_attacked_core", damage)
