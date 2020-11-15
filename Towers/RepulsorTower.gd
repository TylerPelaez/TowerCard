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

func _fire(target: BaseEnemy) -> void:
	return

func build_tower() -> void:
	.build_tower()
	slowField.monitorable = true

func get_class_name():
	return "RepulsorTower"

func upgrade() -> void:
	slow_amount += .1
	if slow_amount >= 0.95:
		slow_amount = 0.95
	
	slowFieldPivot.slow_amount = slow_amount
	slowFieldPivot.particles.amount += 5
	slowFieldPivot.process_material.initial_velocity += 1.0
	
