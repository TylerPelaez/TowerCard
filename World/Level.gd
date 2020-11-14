extends Node2D

class_name Level

onready var enemyPath = $EnemyPath
onready var playerController = $PlayerController
onready var placementArea = $PlacementArea
onready var enemySpawnController = $EnemySpawnController
onready var ui = $UI

export (LevelWaveConfigs.LevelConfig) var level_config = LevelWaveConfigs.LevelConfig.TestLevel

export var core_max_health: float = 20.0
onready var core_health := core_max_health setget set_core_health

var enemies_done_spawning = false
var all_enemies_killed = false
var current_wave: int = 0
var total_waves
var wave_active := false

func _ready():
	playerController.set_level_placement_area(placementArea)
	enemySpawnController.initialize(enemyPath, level_config)
	total_waves = enemySpawnController.get_wave_count()
	ui.set_player_controller(playerController)

func _process(delta: float) -> void:
	if all_enemies_killed && enemies_done_spawning:
		wave_active = false
		all_enemies_killed = false
		enemies_done_spawning = false
		if current_wave == total_waves:
			get_tree().quit()
		
	
	if !wave_active && current_wave < total_waves && Input.is_action_just_pressed("start_wave"):
		_start_wave()

func _start_wave() -> void:
	current_wave += 1
	enemySpawnController.start_wave(current_wave)
	wave_active = true

func _on_EnemySpawnController_wave_finished_spawning():
	enemies_done_spawning = true


func _on_EnemySpawnController_wave_finished_enemy_death():
	all_enemies_killed = true

func set_core_health(value: float):
	core_health = clamp(value, 0, core_max_health)
	if core_health <= 0:
		get_tree().quit()


func _on_EnemySpawnController_spawner_enemy_attacked_core(damage):
	self.core_health -= damage
