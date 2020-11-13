extends PathFollow2D
class_name BaseEnemy

const BASE_SPEED = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_offset(get_offset() + BASE_SPEED * delta)
	
