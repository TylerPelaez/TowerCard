extends Node2D
class_name SlowFieldPivot

onready var slowField = $SlowField/CollisionShape2D
onready var particles = $Particles2D
var draw_range
var spriteOffset
var slow_amount

func _process(delta):
	update()

func _draw():
	if draw_range || Utils.DRAW_DEBUG:
		draw_rect(Rect2(0, -spriteOffset, slowField.shape.extents.x * 2, slowField.shape.extents.y * 2),  Color(0, 0, 1, 0.25))
