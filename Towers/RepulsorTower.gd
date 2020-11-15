extends BaseTower
class_name RepulsorTower

export (float, 0, 1, 0.05) var slow_amount

onready var slowFieldPivot = $SlowFieldPivot
onready var slowField = $SlowFieldPivot/SlowField



func _ready() -> void:
	sprite.modulate = GREEN_TRANSPARENT_COLOR
	draw_range = true
	slowFieldPivot.spriteOffset = $Sprite.texture.get_height() / 2
	slowFieldPivot.slow_amount = slow_amount

func can_rotate()->bool:
	return true

func rotate_tower() -> void:
	if sprite.frame < sprite.hframes - 1:
		sprite.frame += 1
	else:
		sprite.frame = 0
	slowFieldPivot.rotate(deg2rad(90))
	
func _process(delta):
	slowFieldPivot.draw_range = draw_range

func _physics_process(delta: float) -> void:
	if !active:
		return

func _draw() -> void:
	pass

func build_tower() -> void:
	.build_tower()
	slowField.monitorable = true
