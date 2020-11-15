extends Node2D

class_name Level

onready var enemyPath = $EnemyPath
onready var playerController = $PlayerController
onready var enemySpawnController = $EnemySpawnController
onready var ui = $CanvasLayer/UI

export (LevelWaveConfigs.LevelConfig) var level_config = LevelWaveConfigs.LevelConfig.TestLevel

export var core_max_health: float = 100.0
onready var core_health := core_max_health setget set_core_health

var enemies_done_spawning = false
var all_enemies_killed = false
var current_wave: int = 0
var total_waves
var wave_active := false

func _ready():
	enemySpawnController.connect("wave_finished_spawning", self, "_on_EnemySpawnController_wave_finished_spawning")
	enemySpawnController.connect("wave_finished_enemy_death", self, "_on_EnemySpawnController_wave_finished_enemy_death")
	enemySpawnController.connect("spawner_enemy_attacked_core", self, "_on_EnemySpawnController_damage_core")
	
	VisualServer.set_default_clear_color(Color("#222222"))
	
	var placementAreas = []
	for child in get_children():
		if child is Area2D:
			placementAreas.append(child)
	
	playerController.set_level_placement_areas(placementAreas)
	playerController.connect("heal_core", self, "on_core_healed")
	enemySpawnController.initialize(self, enemyPath,level_config)
	total_waves = enemySpawnController.get_wave_count()
	ui.set_player_controller(playerController)
	
	ui.connect("start_wave", self, "_start_wave")
	
	$CanvasLayer/UI/WaveNumber.text = "Wave: " + str(current_wave+1) + "/" + str(total_waves)

func _process(delta: float) -> void:
	$CanvasLayer/UI/CoreHP.text = "Core HP: " + str(core_health)
	
	if all_enemies_killed && enemies_done_spawning:
		ui.end_wave(current_wave, total_waves)
		wave_active = false
		all_enemies_killed = false
		enemies_done_spawning = false
		print("WAVE COMPLETE")
		if current_wave == total_waves:
			# LOAD NEXT LEVEL HERE
			Deck.reset()
			Utils.level = Utils.level + 1
			get_tree().change_scene(Utils.get_scene(Utils.level))	
	
	if !wave_active && current_wave < total_waves && Input.is_action_just_pressed("start_wave"):
		_start_wave()

func _start_wave() -> void:
	ui.start_wave()
	current_wave += 1
	enemySpawnController.start_wave(current_wave)
	wave_active = true

func _on_EnemySpawnController_wave_finished_spawning():
	print("ENEMIES DONE SPAWNING")
	enemies_done_spawning = true


func _on_EnemySpawnController_wave_finished_enemy_death():
	print("ALL ENEMIES KILLED")
	all_enemies_killed = true

func _on_EnemySpawnController_damage_core(damage):
	var newHP = core_health-damage
	set_core_health(newHP)

func set_core_health(value: float):
	core_health = clamp(value, 0, core_max_health)
	if core_health <= 0:
		get_tree().change_scene("res://World/GameOver.tscn")

func on_core_healed(heal_amount):
	self.core_health += heal_amount

func _on_EnemySpawnController_spawner_enemy_attacked_core(damage):
	self.core_health -= damage
