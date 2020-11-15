extends BaseTower
class_name BasicTower

var attack_animations = ["Fire1", "Fire2", "Fire3"]

func _play_attack_animation() -> void:
	attack_animations.shuffle()
	animationPlayer.play(attack_animations[0])
	$ShootSound.play()

func get_class_name():
	return "BasicTower"

func upgrade()-> void:
	self.damage += 1
	self.base_damage += 1
