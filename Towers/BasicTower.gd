extends BaseTower

var attack_animations = ["Fire1", "Fire2", "Fire3"]

func _play_attack_animation() -> void:
	attack_animations.shuffle()
	animationPlayer.play(attack_animations[0])
	$ShootSound.play()
