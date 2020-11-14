extends Area2D
class_name BaseTower

const RED_TRANSPARENT_COLOR: Color = Color(1, 0, 0, 0.5)
const GREEN_TRANSPARENT_COLOR: Color = Color(0, 1, 0, 0.5)
const DEFAULT_COLOR: Color = Color(1, 1, 1, 1)

export var attack_range: float = 30 setget set_attack_range
export var cooldown: float

onready var sprite: Sprite = $Sprite
onready var attackRange: Area2D = $AttackRange
onready var attackRangeCollider: CollisionShape2D = $AttackRange/CollisionShape2D
onready var fireBulletTimer: Timer = $FireBulletTimer

var active: bool = false
var draw_range: bool = false

func _ready() -> void:
	sprite.modulate = GREEN_TRANSPARENT_COLOR
	draw_range = true

func _physics_process(delta: float) -> void:
	if !active:
		return
	
	if fireBulletTimer.time_left <= 0:
		var target = find_target()
		if target != null:
			fire(target)
	
	# Force _draw() to be called
	update()
	

func _draw() -> void:
	if draw_range || Utils.DRAW_DEBUG:
		draw_circle(Vector2.ZERO, attack_range, Color(0, 0, 1, 0.25))
	
func set_attack_range(value: float) -> void:
	attack_range = value
	set_range_collider_size()

func set_range_collider_size() -> void:
	if attackRangeCollider.shape is CircleShape2D:
		attackRangeCollider.shape.radius = attack_range

func build_tower() -> void:
	sprite.modulate = DEFAULT_COLOR
	active = true
	draw_range = false
	attackRangeCollider.disabled = false
	set_range_collider_size()
	fireBulletTimer.time_left = 0

# This returns a BaseEnemy, or null if none found
# TODO: make this not be so terribly inefficient.
func find_target():
	var overlappingAreas = get_overlapping_areas()
	if overlappingAreas.empty():
		return null
	
	var maxUnitOffset: float = -1.0
	var target = null
	for area in overlappingAreas:
		if area is BaseEnemy && area.unit_offset > maxUnitOffset:
			maxUnitOffset = area.unit_offset
			target = area
	return target

func fire(target: BaseEnemy) -> void:
	print("Bang!")

func set_cant_place_color() -> void:
	sprite.modulate = RED_TRANSPARENT_COLOR
	
func set_can_place_color() -> void:
	sprite.modulate = GREEN_TRANSPARENT_COLOR
