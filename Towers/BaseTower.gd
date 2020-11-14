extends Area2D
class_name BaseTower

const cantPlaceColor: Color = Color(1, 0, 0, 0.5)
const transparentColor: Color = Color(1, 1, 1, 0.5)
const opaqueColor: Color = Color(1, 1, 1, 1)

onready var sprite = $Sprite
var active: bool = false

func _ready() -> void:
	sprite.modulate = transparentColor

func _process(delta: float) -> void:
	pass
	
func build_tower() -> void:
	sprite.modulate = opaqueColor
	active = true

func setCantPlaceColor() -> void:
	sprite.modulate = cantPlaceColor
	
func setCanPlaceColor() -> void:
	sprite.modulate = transparentColor
