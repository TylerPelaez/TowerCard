extends BaseTower
class_name LightningTower

const lightning_texture := preload("res://Towers/Lightning.png")
const LightningScene: PackedScene = preload("res://Other/Lightning.tscn")

onready var lightningOrigin = $LightningOrigin
onready var stopLightningTimer = $StopLightingTimer
onready var lightningLine = $LightningLine

export var chain_limit := 3
export var bounce_range := 10

var is_firing_lightning := false
var sent_lightnings := []

func _process(delta):
	._process(delta)
	if is_firing_lightning and !sent_lightnings.empty():
		lightningLine.clear_points()
		for lightning in sent_lightnings:
			if lightning.initialized:
				if lightningLine.points.empty():
					lightningLine.add_point(lightningOrigin.position)
				
				lightningLine.add_point(transform.xform_inv(lightning.global_position))
	

func _fire(target: BaseEnemy) -> void:
	is_firing_lightning = true
	animationPlayer.play("Attack")
	$ShootSound.play()
	stopLightningTimer.start()
	fireBulletTimer.start()
	_cast_lightning(target)
	
func _cast_lightning(target: BaseEnemy):
	var instance = Utils.instance_scene_on_main(LightningScene, target.global_position)
	instance.chain_limit = chain_limit
	instance.damage = damage
	instance.target = target
	instance.connect("create_lightning", self, "_on_new_lightning")
	instance.bounceCollider.shape.radius = bounce_range
	_on_new_lightning(instance)
	instance.already_hit = []
	instance.initialized = true
	
func _on_new_lightning(newLightning) -> void:
	sent_lightnings.append(newLightning)

func _on_StopLightingTimer_timeout():
	for lightning in sent_lightnings:
		lightning.queue_free()
	sent_lightnings.clear()
	lightningLine.clear_points()
	is_firing_lightning = false
	animationPlayer.play("Idle")

func get_class_name():
	return "LightningTower"

func upgrade() -> void:
	chain_limit += 1
