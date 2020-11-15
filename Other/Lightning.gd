extends Node2D
class_name Lightning

signal create_lightning(instance)

onready var bounceArea = $BounceArea
onready var bounceCollider = $BounceArea/BounceCollider

var chain_limit
var sent_lightning := false
var damaged_target := false
var damage
var target
var initialized = false
var already_hit = []

func _physics_process(delta):
	if !initialized:
		return
	
	if target == null:
		initialized = false
		return
	
	global_position = target.global_position
	
	if !damaged_target:
		target._on_Hurtbox_hit(damage)
		damaged_target = true
	
	if chain_limit == 0 and !sent_lightning:
		sent_lightning = true

	if !sent_lightning:
		var areas = bounceArea.get_overlapping_areas()
		for area in areas:
			var enemy = area.get_parent()
			if enemy is BaseEnemy and already_hit.find(enemy) == -1 and enemy != target:
				var instance = Utils.instance_scene_on_main(load("res://Other/Lightning.tscn"), area.get_parent().global_position)
				instance.chain_limit = chain_limit - 1
				instance.connect("create_lightning", self, "_on_create_lightning")
				instance.target = enemy
				instance.damage = damage
				instance.already_hit = already_hit + [target]
				instance.initialized = true
				instance.bounceCollider.shape.radius = bounceCollider.shape.radius 
				
				emit_signal("create_lightning", instance)
				sent_lightning = true
				break
	
				
func _on_create_lightning(instance: Lightning):
	emit_signal("create_lightning", instance)
